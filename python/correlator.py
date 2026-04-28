"""
Correlator: cross-correlation, integration, UV synthesis, fringe fitting,
dirty-image generation, and FITS export.

  - calc_correlations_numpy():        vectorised upper-triangular cross-products
  - _compute_baselines_wavelengths(): UV coords per baseline & freq channel from LST
  - _save_uv_to_fits():               write accumulated UV visibilities to FITS
  - correlate_process():              worker that integrates spectra and emits UV / correlation frames
"""

import multiprocessing as mp
import numpy as np
import queue

from settings import (INTEGRATION_COUNT, ANTENNA_POSITIONS_ENU,
                      CHANNEL_TO_ANTENNA, DC_NOTCH_KHZ, IFFT_GRID_SIZE,
                      SOURCE_RA_DEG, OBSERVATION_DECLINATION_DEG)


# Correlation helpers
_triu_i, _triu_j = np.triu_indices(4)
_corr_keys = [f"{i}{j}" for i, j in zip(_triu_i, _triu_j)]


def calc_correlations_numpy(latest):
    combined = latest[_triu_i] * np.conj(latest[_triu_j])
    return {k: combined[idx] for idx, k in enumerate(_corr_keys)}


def _compute_baselines_wavelengths(antenna_positions, chan_to_ant, freq_hz,
                                    lat_deg, lon_deg, dec_deg, ra_deg=0.0):
    """Return {"ij": (u, v, w)} arrays per cross-baseline (units: wavelengths).
    Hour angle H = LST - RA; w is the projection along the source direction
    used for fringe stopping (geometric delay  tau_g = w / freq_hz).
    """
    from datetime import datetime, timezone
    c = 299792458.0

    # ── compute Local Sidereal Time & hour angle ──
    now = datetime.now(timezone.utc)
    jd = (
        367 * now.year
        - int(7 * (now.year + int((now.month + 9) / 12)) / 4)
        + int(275 * now.month / 9)
        + now.day
        + 1721013.5
        + (now.hour + now.minute / 60.0 + now.second / 3600.0) / 24.0
    )
    T = (jd - 2451545.0) / 36525.0
    gmst_deg = (280.46061837
                + 360.98564736629 * (jd - 2451545.0)
                + 0.000387933 * T**2
                - T**3 / 38710000.0) % 360.0
    lst_deg = (gmst_deg + lon_deg) % 360.0

    # hour angle of the *source*: H = LST - RA  (RA = 0 → H = LST = drift mode)
    H = np.radians((lst_deg - ra_deg) % 360.0)
    lat = np.radians(lat_deg)
    dec = np.radians(dec_deg)

    sin_H, cos_H = np.sin(H), np.cos(H)
    sin_d, cos_d = np.sin(dec), np.cos(dec)
    sin_l, cos_l = np.sin(lat), np.cos(lat)

    pos = np.array(antenna_positions)  # (N_ant, 3) ENU metres
    wavelengths = c / freq_hz          # (n_freq,)
    uv_dict = {}

    for i in range(4):
        for j in range(i + 1, 4):
            ai, aj = chan_to_ant[i], chan_to_ant[j]
            if ai == aj:
                continue
            dE = pos[aj][0] - pos[ai][0]
            dN = pos[aj][1] - pos[ai][1]
            dU = pos[aj][2] - pos[ai][2]

            # ENU → (u, v, w) projection (Thompson, Moran & Swenson, dropping dU → 0)
            u_m =  dE * cos_H               - dN * sin_l * sin_H
            v_m =  dE * sin_d * sin_H       + dN * (sin_l * sin_d * cos_H + cos_l * cos_d)
            w_m = -dE * cos_d * sin_H       + dN * (cos_l * sin_d - sin_l * cos_d * cos_H)

            u = u_m / wavelengths
            v = v_m / wavelengths
            w = w_m / wavelengths
            uv_dict[f"{i}{j}"] = (u, v, w)

    return uv_dict


def _save_uv_to_fits(path, u, v, amp, phase, avg_corr, ant_pos, chan_to_ant, int_count):
    try:
        from astropy.io import fits
        import settings as _s
        from datetime import datetime, timezone

        hdr = fits.Header()
        hdr["ORIGIN"]   = "FX_Correlator"
        hdr["DATE-OBS"] = datetime.now(timezone.utc).isoformat()
        hdr["TELESCOP"] = "FMComms5 Array"
        hdr["INSTRUME"] = "FX Correlator"
        hdr["OBS_LAT"]  = (_s.OBSERVATION_LATITUDE_DEG, "[deg] Observatory latitude")
        hdr["OBS_LON"]  = (_s.OBSERVATION_LONGITUDE_DEG, "[deg] Observatory longitude")
        hdr["OBS_DEC"]  = (_s.OBSERVATION_DECLINATION_DEG, "[deg] Source declination")
        hdr["FREQ"]     = (_s.rx_lo, "[Hz] Centre frequency (LO)")
        hdr["BANDWDTH"] = (_s.rx_rf_bandwidth, "[Hz] RF bandwidth")
        hdr["SAMPRATE"] = (_s.rx_sample_rate, "[Hz] Sample rate")
        hdr["NFFT"]     = (_s.P, "FFT size (channels)")
        hdr["NTAPS"]    = (_s.M, "PFB taps")
        hdr["PFB_WIN"]  = (_s.PFB_WINDOW, "PFB window function")
        hdr["FFTSHIFT"] = (_s.PFB_FFTSHIFT, "FFT shift applied")
        hdr["INTCOUNT"] = (int_count, "Integration count (frames)")
        hdr["N_UV_PTS"] = (int(u.size), "Total accumulated UV points")
        for ai in range(len(ant_pos)):
            hdr[f"ANT{ai}_E"] = (float(ant_pos[ai][0]), f"[m] Antenna {ai} East")
            hdr[f"ANT{ai}_N"] = (float(ant_pos[ai][1]), f"[m] Antenna {ai} North")
            hdr[f"ANT{ai}_U"] = (float(ant_pos[ai][2]) if len(ant_pos[ai]) > 2 else 0.0,
                                 f"[m] Antenna {ai} Up")
        for ch, ant in chan_to_ant.items():
            hdr[f"CH{ch}_ANT"] = (ant, f"Channel {ch} -> Antenna index")
        primary = fits.PrimaryHDU(header=hdr)

        vis = amp * np.exp(1j * phase)
        cols = [
            fits.Column(name="U",        format="D", array=u,     unit="wavelengths"),
            fits.Column(name="V",        format="D", array=v,     unit="wavelengths"),
            fits.Column(name="AMP",      format="D", array=amp),
            fits.Column(name="PHASE",    format="D", array=phase, unit="rad"),
            fits.Column(name="VIS_REAL", format="D", array=vis.real),
            fits.Column(name="VIS_IMAG", format="D", array=vis.imag),
        ]
        uv_table = fits.BinTableHDU.from_columns(cols, name="UV_DATA")

        corr_cols = []
        if avg_corr:
            for bkey in sorted(avg_corr.keys()):
                spec = avg_corr[bkey]
                corr_cols.append(fits.Column(name=f"REAL_{bkey}", format="D", array=spec.real))
                corr_cols.append(fits.Column(name=f"IMAG_{bkey}", format="D", array=spec.imag))
        if corr_cols:
            corr_table = fits.BinTableHDU.from_columns(corr_cols, name="AVG_CORR")
            hdul = fits.HDUList([primary, uv_table, corr_table])
        else:
            hdul = fits.HDUList([primary, uv_table])

        hdul.writeto(path, overwrite=True)
        print(f"correlate: saved FITS → {path}  ({u.size} UV points)")

    except ImportError:
        print("correlate: ERROR — astropy not installed, cannot save FITS")
    except Exception as e:
        print(f"correlate: FITS save error: {e}")


def _save_dirty_fits(path, u, v, amp, phase, N, ant_pos, chan_to_ant, int_count):
    """
    Export the current dirty image as a standard 2-D FITS image.

    Follows the AIPS/CASA convention:
      - Primary HDU holds a NAXIS=2 float32 image
      - WCS axes:  CTYPE1 = "RA---SIN",  CTYPE2 = "DEC--SIN"
      - CDELT in degrees per pixel (positive m = +dec, negative l = +ra is
        the standard "east-left" convention used by DS9 and all major
        radio-astronomy viewers)
      - BUNIT = "JY/BEAM" (arbitrary scale until flux-calibrated)

    Also emits:
      - A PSF (dirty-beam) image as an IMAGE extension named "PSF"
      - A BinTable of the raw UV visibilities named "UV_DATA" so the file
        is self-contained and can be re-gridded or CLEANed offline.
    """
    try:
        from astropy.io import fits
        import settings as _s
        from datetime import datetime, timezone

        # ── grid UV and compute dirty image + PSF ───────────────────────────
        uv_max = max(np.abs(u).max(), np.abs(v).max(), 1.0) * 1.05
        # FFT-centered gridding: DC bin at index N//2 (see live correlator).
        ui = np.floor((u / uv_max + 1.0) * 0.5 * N).astype(int)
        vi = np.floor((v / uv_max + 1.0) * 0.5 * N).astype(int)
        np.clip(ui, 0, N - 1, out=ui)
        np.clip(vi, 0, N - 1, out=vi)

        vis   = amp * np.exp(1j * phase)
        grid  = np.zeros((N, N), dtype=np.complex128)
        wt    = np.zeros((N, N), dtype=np.float64)
        np.add.at(grid, (vi, ui), vis)
        np.add.at(wt,   (vi, ui), 1.0)
        m = wt > 0
        grid[m] /= wt[m]

        pgrid = np.zeros((N, N), dtype=np.complex128)
        np.add.at(pgrid, (vi, ui), np.ones_like(vis))
        pwt = wt.copy()
        pm = pwt > 0
        pgrid[pm] /= pwt[pm]

        dirty = np.fft.ifftshift(np.fft.ifft2(np.fft.fftshift(grid))).real
        psf   = np.fft.ifftshift(np.fft.ifft2(np.fft.fftshift(pgrid))).real
        ppeak = np.abs(psf).max()
        if ppeak > 0:
            psf = psf / ppeak

        # ── WCS: direction cosines (l,m) → (RA,Dec) tangent plane ──────────
        # pixel scale in direction-cosine units:
        dl = 1.0 / (2.0 * uv_max)           # radians per pixel
        dl_deg = float(np.degrees(dl))

        ra_deg  = float(getattr(_s, "SOURCE_RA_DEG", 0.0))
        dec_deg = float(_s.OBSERVATION_DECLINATION_DEG)

        hdr = fits.Header()
        hdr["ORIGIN"]   = "FX_Correlator"
        hdr["DATE-OBS"] = datetime.now(timezone.utc).isoformat()
        hdr["TELESCOP"] = "FMComms5 Array"
        hdr["INSTRUME"] = "FX Correlator"
        hdr["OBJECT"]   = "UNKNOWN"
        hdr["BUNIT"]    = ("JY/BEAM", "Brightness units (uncalibrated)")
        hdr["EQUINOX"]  = 2000.0
        hdr["RADESYS"]  = "ICRS"

        # 2-axis WCS.  SIN projection is the radio-astronomy standard for
        # small-field aperture-synthesis images.
        hdr["WCSAXES"]  = 2
        hdr["CTYPE1"]   = "RA---SIN"
        hdr["CTYPE2"]   = "DEC--SIN"
        hdr["CUNIT1"]   = "deg"
        hdr["CUNIT2"]   = "deg"
        hdr["CRPIX1"]   = N / 2 + 1          # FITS is 1-indexed
        hdr["CRPIX2"]   = N / 2 + 1
        hdr["CRVAL1"]   = ra_deg
        hdr["CRVAL2"]   = dec_deg
        hdr["CDELT1"]   = -dl_deg            # RA decreases to the right
        hdr["CDELT2"]   =  dl_deg

        # observation metadata
        hdr["OBS_LAT"]  = (_s.OBSERVATION_LATITUDE_DEG,  "[deg] Observatory latitude")
        hdr["OBS_LON"]  = (_s.OBSERVATION_LONGITUDE_DEG, "[deg] Observatory longitude")
        hdr["FREQ"]     = (_s.rx_lo,                     "[Hz] Centre frequency (LO)")
        hdr["BANDWDTH"] = (_s.rx_rf_bandwidth,           "[Hz] RF bandwidth")
        hdr["SAMPRATE"] = (_s.rx_sample_rate,            "[Hz] Sample rate")
        hdr["NFFT"]     = (_s.P,                         "FFT size (channels)")
        hdr["INTCOUNT"] = (int_count,                    "Integration count (frames)")
        hdr["N_UV_PTS"] = (int(u.size),                  "Accumulated UV points")
        hdr["UV_MAX"]   = (float(uv_max),                "[wavelengths] Max |u|,|v|")
        hdr["GRIDSIZE"] = (int(N),                       "Image dimension N (N x N)")
        for ai in range(len(ant_pos)):
            hdr[f"ANT{ai}_E"] = (float(ant_pos[ai][0]), f"[m] Antenna {ai} East")
            hdr[f"ANT{ai}_N"] = (float(ant_pos[ai][1]), f"[m] Antenna {ai} North")
            hdr[f"ANT{ai}_U"] = (float(ant_pos[ai][2]) if len(ant_pos[ai]) > 2 else 0.0,
                                 f"[m] Antenna {ai} Up")
        for ch, ant in chan_to_ant.items():
            hdr[f"CH{ch}_ANT"] = (ant, f"Channel {ch} -> Antenna index")
        hdr.add_comment("Dirty image = IFFT(gridded visibilities).real (Hermitian-symmetric UV).")
        hdr.add_comment("Hogbom CLEAN: open this file in the standalone CLEAN app.")

        primary = fits.PrimaryHDU(data=dirty.astype(np.float32), header=hdr)

        # PSF extension (same WCS)
        psf_hdr = hdr.copy()
        psf_hdr["EXTNAME"] = "PSF"
        psf_hdr["BUNIT"]   = "1"
        psf_ext = fits.ImageHDU(data=psf.astype(np.float32), header=psf_hdr, name="PSF")

        # UV_DATA extension
        cols = [
            fits.Column(name="U",     format="D", array=u,     unit="wavelengths"),
            fits.Column(name="V",     format="D", array=v,     unit="wavelengths"),
            fits.Column(name="AMP",   format="D", array=amp),
            fits.Column(name="PHASE", format="D", array=phase, unit="rad"),
        ]
        uv_ext = fits.BinTableHDU.from_columns(cols, name="UV_DATA")

        hdul = fits.HDUList([primary, psf_ext, uv_ext])
        hdul.writeto(path, overwrite=True)
        print(f"correlate: saved dirty-image FITS → {path}  ({N}x{N}, {u.size} UV pts)")

    except ImportError:
        print("correlate: ERROR — astropy not installed, cannot save FITS")
    except Exception as e:
        print(f"correlate: dirty-FITS save error: {e}")


def correlate_process(pfb_queue, corr_plot_queue, stop_event, corr_config_queue):
    _int_count = INTEGRATION_COUNT
    _ant_pos = list(ANTENNA_POSITIONS_ENU)
    _chan_to_ant = dict(CHANNEL_TO_ANTENNA)

    # accumulators  —  keyed by "ij"
    _acc = {}           # running sum of cross-products
    _acc_n = 0          # frames accumulated so far
    _avg = {}           # last completed average
    _uv = {}            # UV coords for cross-baselines
    _avg_seq = 0        # incremented each completed integration
    _pfb_seq = 0        # incremented each PFB frame

    # persistent UV accumulators (Earth-rotation synthesis)
    _uv_acc_u = np.array([])
    _uv_acc_v = np.array([])
    _uv_acc_amp = np.array([])
    _uv_acc_phase = np.array([])
    _MAX_UV = 100_000_000
    _grid_size = int(IFFT_GRID_SIZE)
    _MAX_SCATTER_PTS = 50_000

    # ── fringe-fitting calibration state ──
    _cal = {}
    _cal_enabled = False

    # ── DC notch state ──
    _dc_notch_khz = DC_NOTCH_KHZ

    # ── source-tracking / fringe-stopping state ──
    _source_ra_deg = float(SOURCE_RA_DEG)
    _source_dec_deg = float(OBSERVATION_DECLINATION_DEG)
    _fringe_stop_enabled = True

    # ── auto-correlation normalization ──
    # Cross-baselines: divide by sqrt(|V_ii|·|V_jj|) → unitless coherence ∈ [0,1]
    # Auto-baselines:  divide by |V_ii|             → flat unity (kills band shape)
    # The two are independently toggleable; autos default OFF so the band shape
    # remains visible in spectrum / waterfall plots.
    _autocorr_norm_cross = True
    _autocorr_norm_autos = False

    # ── RFI flagging (MAD on auto-power) ──
    # Per integration: build a per-channel boolean mask from the auto-corr
    # power spectra using the Median Absolute Deviation (MAD), then zero out
    # those channels in every baseline before normalisation. Catches AD9361
    # fractional-N spurs (whose locations change every boot) plus narrowband
    # external RFI, with no static configuration required.
    _rfi_flag_enabled = True
    _rfi_sigma = 5.0
    _flagged_frac = 0.0

    while not stop_event.is_set():
        # ── drain config queue ──
        try:
            while True:
                cfg = corr_config_queue.get_nowait()
                if "integration_count" in cfg:
                    _int_count = cfg["integration_count"]
                if "antenna_positions" in cfg:
                    _ant_pos = cfg["antenna_positions"]
                if "channel_to_antenna" in cfg:
                    _chan_to_ant = cfg["channel_to_antenna"]
                if cfg.get("reset"):
                    _acc.clear()
                    _acc_n = 0
                    _avg.clear()
                if cfg.get("clear_uv"):
                    _uv_acc_u = np.array([])
                    _uv_acc_v = np.array([])
                    _uv_acc_amp = np.array([])
                    _uv_acc_phase = np.array([])
                    print("correlate: UV data cleared")
                if cfg.get("fringe_fit"):
                    if _avg:
                        import settings as _s_cal
                        _fs_cal = _s_cal.rx_sample_rate
                        _cal.clear()
                        for bkey, vis in _avg.items():
                            a, b = int(bkey[0]), int(bkey[1])
                            if a == b:
                                continue
                            delay_spec = np.fft.ifft(vis)
                            n_ch = len(vis)
                            peak_bin = int(np.argmax(np.abs(delay_spec)))
                            amp_arr = np.abs(delay_spec)
                            if 0 < peak_bin < n_ch - 1:
                                a0 = amp_arr[peak_bin - 1]
                                a1 = amp_arr[peak_bin]
                                a2 = amp_arr[peak_bin + 1]
                                denom = (2.0 * a1 - a0 - a2)
                                delta = 0.5 * (a0 - a2) / denom if abs(denom) > 1e-30 else 0.0
                            else:
                                delta = 0.0
                            refined_bin = peak_bin + delta
                            if refined_bin > n_ch / 2:
                                refined_bin -= n_ch
                            delay_s = refined_bin / _fs_cal
                            phase_rad = float(np.angle(delay_spec[peak_bin]))
                            _cal[bkey] = {"delay": delay_s, "phase": phase_rad}
                            print(f"correlate: fringe fit {bkey}  "
                                  f"delay={delay_s*1e9:.2f} ns  "
                                  f"phase={np.degrees(phase_rad):.1f}°")
                        _cal_enabled = True
                        print(f"correlate: fringe fit complete — {len(_cal)} baselines calibrated")
                    else:
                        print("correlate: fringe fit requested but no averaged data yet")
                if cfg.get("clear_cal"):
                    _cal.clear()
                    _cal_enabled = False
                    print("correlate: calibration cleared")
                if "dc_notch_khz" in cfg:
                    _dc_notch_khz = float(cfg["dc_notch_khz"])
                    print(f"correlate: DC notch width → ±{_dc_notch_khz:.1f} kHz")
                if "ifft_grid_size" in cfg:
                    _grid_size = int(cfg["ifft_grid_size"])
                    print(f"correlate: IFFT grid size → {_grid_size}×{_grid_size}")
                if "source_ra_deg" in cfg:
                    _source_ra_deg = float(cfg["source_ra_deg"]) % 360.0
                    print(f"correlate: source RA → {_source_ra_deg:.4f}°")
                if "source_dec_deg" in cfg:
                    _source_dec_deg = float(cfg["source_dec_deg"])
                    print(f"correlate: source Dec → {_source_dec_deg:.4f}°")
                if "fringe_stop" in cfg:
                    _fringe_stop_enabled = bool(cfg["fringe_stop"])
                    print(f"correlate: fringe-stopping {'ON' if _fringe_stop_enabled else 'OFF'}")
                if "autocorr_norm_cross" in cfg:
                    _autocorr_norm_cross = bool(cfg["autocorr_norm_cross"])
                    print(f"correlate: auto-corr normalization (cross) {'ON' if _autocorr_norm_cross else 'OFF'}")
                if "autocorr_norm_autos" in cfg:
                    _autocorr_norm_autos = bool(cfg["autocorr_norm_autos"])
                    print(f"correlate: auto-corr normalization (autos) {'ON' if _autocorr_norm_autos else 'OFF'}")
                if "rfi_flag" in cfg:
                    _rfi_flag_enabled = bool(cfg["rfi_flag"])
                    print(f"correlate: RFI flagging {'ON' if _rfi_flag_enabled else 'OFF'}")
                if "rfi_sigma" in cfg:
                    _rfi_sigma = float(cfg["rfi_sigma"])
                    print(f"correlate: RFI flag threshold → {_rfi_sigma:.1f}σ")
                if cfg.get("save_fits"):
                    _save_uv_to_fits(
                        cfg["save_fits"],
                        _uv_acc_u, _uv_acc_v, _uv_acc_amp, _uv_acc_phase,
                        _avg, _ant_pos, _chan_to_ant, _int_count,
                    )
                if cfg.get("clear_wf"):
                    _avg_seq = 0
                    _pfb_seq = 0
                    print("correlate: waterfall seq reset")
                if cfg.get("save_dirty_fits"):
                    # Snapshot current UV accumulator, grid to dirty image,
                    # and write a standard FITS image with WCS headers.
                    if _uv_acc_u.size == 0:
                        print("correlate: dirty-FITS requested but no UV data yet")
                    else:
                        try:
                            _save_dirty_fits(
                                cfg["save_dirty_fits"],
                                _uv_acc_u, _uv_acc_v, _uv_acc_amp, _uv_acc_phase,
                                int(_grid_size), _ant_pos, _chan_to_ant, _int_count,
                            )
                        except Exception as e:
                            print(f"correlate: dirty-FITS save failed: {e}")
                print(f"correlate: config updated  int_count={_int_count}")
        except Exception:
            pass

        try:
            pfb_data = pfb_queue.get(timeout=0.1)
        except Exception:
            continue

        try:
            latest = pfb_data["latest"]       # shape (4, P) complex
            _pfb_seq += 1

            # ── apply DC notch (zero bins around DC) ──
            if _dc_notch_khz > 0:
                import settings as _s_notch
                _fs_notch = _s_notch.rx_sample_rate
                _P_notch = latest.shape[1]
                bin_width_khz = (_fs_notch / _P_notch) / 1e3
                n_bins = int(np.ceil(_dc_notch_khz / bin_width_khz))
                if _s_notch.PFB_FFTSHIFT:
                    dc_idx = _P_notch // 2
                    lo = max(0, dc_idx - n_bins)
                    hi = min(_P_notch, dc_idx + n_bins + 1)
                    latest = latest.copy()
                    latest[:, lo:hi] = 0.0
                else:
                    latest = latest.copy()
                    latest[:, :n_bins + 1] = 0.0
                    if n_bins > 0:
                        latest[:, -n_bins:] = 0.0

            # instantaneous cross-products
            correlations = {}
            for i in range(4):
                for j in range(i, 4):
                    correlations[f"{i}{j}"] = latest[i] * np.conj(latest[j])

            # ── accumulate for averaging ──
            first_key = next(iter(correlations))
            if first_key in _acc and _acc[first_key].shape != correlations[first_key].shape:
                _acc.clear()
                _acc_n = 0
            for key, val in correlations.items():
                if key in _acc:
                    _acc[key] += val
                else:
                    _acc[key] = val.copy()
            _acc_n += 1

            if _acc_n >= _int_count and _int_count > 0:
                _avg = {k: v / _acc_n for k, v in _acc.items()}
                _acc.clear()
                _acc_n = 0
                _avg_seq += 1

                # ── RFI flagging (MAD on auto-power, applied to all baselines) ──
                # Algorithm:
                #   1. For each antenna a, take p_a = |V_aa(f)| (the auto-power
                #      spectrum — highest SNR, no fringe phase to worry about).
                #   2. Compute the median (med) and Median Absolute Deviation
                #      (MAD) of p_a over frequency. MAD is the robust analogue
                #      of standard deviation; the factor 1.4826 converts MAD
                #      to an estimate of σ for Gaussian-distributed noise.
                #   3. Flag any channel where |p_a − med| > N·σ, with N = _rfi_sigma
                #      (default 5.0). Robust against the RFI itself biasing
                #      the threshold (which mean/std-based thresholds suffer
                #      from severely).
                #   4. Union the per-antenna masks: a channel flagged on ANY
                #      antenna is flagged everywhere. This is conservative —
                #      we lose channels that one antenna sees but others don't,
                #      but it ensures cross-baselines never include a corrupt
                #      side. Acceptable since FMComms5 antennas all see the
                #      same RF environment and most spurs are common-mode.
                #   5. Zero out flagged channels in every baseline (autos and
                #      crosses). Auto-corr normalisation later sees these as
                #      zero-power channels and the np.where guard returns 0.
                if _rfi_flag_enabled and _avg:
                    _P_flag = next(iter(_avg.values())).shape[0]
                    chan_flag = np.zeros(_P_flag, dtype=bool)
                    for a in range(4):
                        k = f"{a}{a}"
                        if k not in _avg:
                            continue
                        p = np.abs(_avg[k]).astype(np.float64)
                        med = np.median(p)
                        mad = np.median(np.abs(p - med))
                        sigma = 1.4826 * mad + 1e-30
                        chan_flag |= np.abs(p - med) > (_rfi_sigma * sigma)
                    _flagged_frac = float(chan_flag.mean())
                    if chan_flag.any():
                        for bkey in _avg:
                            _avg[bkey] = np.where(chan_flag, 0.0 + 0.0j, _avg[bkey])
                else:
                    _flagged_frac = 0.0

                # ── auto-correlation normalization (coherence) ──
                # Two independent toggles:
                #   _autocorr_norm_cross : V_ij / sqrt(|V_ii|·|V_jj|)  → coherence ∈ [0,1]
                #   _autocorr_norm_autos : V_ii / |V_ii|               → unity (flat)
                # Autos default OFF so band-shape stays visible; crosses default ON
                # so cross-baselines are gain-independent.
                if _autocorr_norm_cross or _autocorr_norm_autos:
                    _autos = {}
                    for a in range(4):
                        k = f"{a}{a}"
                        if k in _avg:
                            _autos[a] = np.abs(_avg[k]).astype(np.float64)
                    _eps = 1e-30
                    for bkey in list(_avg.keys()):
                        a, b = int(bkey[0]), int(bkey[1])
                        if a == b:
                            if not _autocorr_norm_autos:
                                continue
                            p = _autos.get(a)
                            if p is not None:
                                _avg[bkey] = np.where(p > _eps, _avg[bkey] / (p + _eps), 0.0)
                            continue
                        if not _autocorr_norm_cross:
                            continue
                        pa = _autos.get(a)
                        pb = _autos.get(b)
                        if pa is None or pb is None:
                            continue
                        denom = np.sqrt(pa * pb) + _eps
                        _avg[bkey] = _avg[bkey] / denom

                # compute UV coords for the cross-baselines
                P_cur = latest.shape[1]
                try:
                    import settings as _s
                    fs = _s.rx_sample_rate
                    lo = _s.rx_lo
                    freq = np.fft.fftfreq(P_cur, d=1.0 / fs) + lo
                    if _s.PFB_FFTSHIFT:
                        freq = np.fft.fftshift(freq)
                    _uv = _compute_baselines_wavelengths(
                        _ant_pos, _chan_to_ant, freq,
                        _s.OBSERVATION_LATITUDE_DEG,
                        _s.OBSERVATION_LONGITUDE_DEG,
                        _source_dec_deg,
                        ra_deg=_source_ra_deg,
                    )
                except Exception as e:
                    print(f"UV compute error: {e}")

                # ── apply fringe-stop rotation (track source phase center) ──
                # With V_ij = X_i · conj(X_j) and baseline D = r_j − r_i (i<j),
                # the raw correlator output for a point source at the phase
                # center carries phase exp(−i 2π w). Removing that fringe
                # requires multiplying by exp(+i 2π w) so the corrected
                # visibility is real-positive at field center.
                if _avg and _uv and _fringe_stop_enabled:
                    for bkey, vis in list(_avg.items()):
                        if bkey in _uv:
                            w_arr = _uv[bkey][2]   # (n_freq,) wavelengths
                            if w_arr.shape == vis.shape:
                                _avg[bkey] = vis * np.exp(+1j * 2.0 * np.pi * w_arr)

                # ── apply fringe-fit calibration to cross-baselines ──
                _avg_cal = {}
                if _avg:
                    import settings as _s_freq
                    _P_cal = latest.shape[1]
                    _fs_freq = _s_freq.rx_sample_rate
                    _f_axis = np.arange(_P_cal, dtype=np.float64) * (_fs_freq / _P_cal)
                    for bkey, vis in _avg.items():
                        a_i, b_i = int(bkey[0]), int(bkey[1])
                        if a_i == b_i or not _cal_enabled or bkey not in _cal:
                            _avg_cal[bkey] = vis
                        else:
                            c = _cal[bkey]
                            correction = np.exp(-1j * (2.0 * np.pi * _f_axis * c["delay"] + c["phase"]))
                            _avg_cal[bkey] = vis * correction

                # ── accumulate UV points for Earth-rotation tracks ──
                if _avg_cal and _uv:
                    u_list, v_list, amp_list, phase_list = [], [], [], []
                    for bkey, uvw in _uv.items():
                        u_arr, v_arr = uvw[0], uvw[1]
                        if bkey in _avg_cal:
                            vis = _avg_cal[bkey]
                            u_list.append(u_arr)
                            v_list.append(v_arr)
                            amp_list.append(np.abs(vis))
                            phase_list.append(np.angle(vis))
                            # conjugate baseline
                            u_list.append(-u_arr)
                            v_list.append(-v_arr)
                            amp_list.append(np.abs(vis))
                            phase_list.append(-np.angle(vis))
                    if u_list:
                        _uv_acc_u = np.concatenate([_uv_acc_u, np.concatenate(u_list)])
                        _uv_acc_v = np.concatenate([_uv_acc_v, np.concatenate(v_list)])
                        _uv_acc_amp = np.concatenate([_uv_acc_amp, np.concatenate(amp_list)])
                        _uv_acc_phase = np.concatenate([_uv_acc_phase, np.concatenate(phase_list)])
                        if _uv_acc_u.size > _MAX_UV:
                            _uv_acc_u = _uv_acc_u[-_MAX_UV:]
                            _uv_acc_v = _uv_acc_v[-_MAX_UV:]
                            _uv_acc_amp = _uv_acc_amp[-_MAX_UV:]
                            _uv_acc_phase = _uv_acc_phase[-_MAX_UV:]

                # ── compute dirty image in-process (128×128 FFT is cheap) ──
                _dirty_result = None
                if _uv_acc_u.size > 0:
                    try:
                        N = _grid_size
                        _vis = _uv_acc_amp * np.exp(1j * _uv_acc_phase)
                        _uv_max = max(np.abs(_uv_acc_u).max(), np.abs(_uv_acc_v).max(), 1.0) * 1.05
                        # Map (u,v) ∈ [-uv_max, +uv_max] → integer cell with the
                        # FFT DC bin at index N//2 so the appended Hermitian
                        # conjugate pair (-u,-v) lands symmetrically about the
                        # FFT center. Using (N-1) here would offset by half a
                        # pixel and leak power into the imaginary part.
                        _ui = np.floor((_uv_acc_u / _uv_max + 1.0) * 0.5 * N).astype(int)
                        _vi = np.floor((_uv_acc_v / _uv_max + 1.0) * 0.5 * N).astype(int)
                        np.clip(_ui, 0, N - 1, out=_ui)
                        np.clip(_vi, 0, N - 1, out=_vi)
                        _grid = np.zeros((N, N), dtype=complex)
                        _wt = np.zeros((N, N), dtype=float)
                        np.add.at(_grid, (_vi, _ui), _vis)
                        np.add.at(_wt, (_vi, _ui), 1.0)
                        _m = _wt > 0
                        _grid[_m] /= _wt[_m]
                        _dirty = np.fft.ifftshift(np.fft.ifft2(np.fft.fftshift(_grid)))
                        _dl = 1.0 / (2.0 * _uv_max)
                        # The UV accumulator is Hermitian-symmetrized (conjugate
                        # baselines appended), so the IFFT is mathematically real.
                        # Any imaginary residue is pure gridding noise — take the
                        # real part (same image CLEAN operates on). Clip negative
                        # PSF sidelobes to zero for display: rectifying with
                        # np.abs() instead would fold negative troughs into bright
                        # stripes and turn the zero crossings into hard black
                        # lines (visible as diagonal streaks across the image).
                        _dirty_result = {
                            "dirty_abs": np.clip(_dirty.real, 0.0, None).astype(np.float32),
                            "lm_extent": _dl * N / 2.0,
                        }
                    except Exception as e:
                        print(f"correlate dirty image error: {e}")

                # ── downsample UV scatter data for UI ──
                _uv_scatter = None
                if _uv_acc_u.size > 0:
                    n_pts = _uv_acc_u.size
                    if n_pts > _MAX_SCATTER_PTS:
                        step = n_pts // _MAX_SCATTER_PTS
                        sl = slice(None, None, step)
                    else:
                        sl = slice(None)
                    _uv_scatter = {
                        "u": _uv_acc_u[sl].astype(np.float32),
                        "v": _uv_acc_v[sl].astype(np.float32),
                        "amp": _uv_acc_amp[sl].astype(np.float32),
                        "phase": _uv_acc_phase[sl].astype(np.float32),
                        "u_min": float(_uv_acc_u.min()),
                        "u_max": float(_uv_acc_u.max()),
                        "v_min": float(_uv_acc_v.min()),
                        "v_max": float(_uv_acc_v.max()),
                        "total_pts": n_pts,
                    }

                # push to UI only when integration completes
                corr_frame = {
                    "correlations": correlations,
                    "avg_correlations": _avg_cal if _avg_cal else None,
                    "avg_seq": _avg_seq,
                    "avg_count": _int_count,
                    "uv_scatter": _uv_scatter,
                    "dirty_result": _dirty_result,
                    "flagged_frac": _flagged_frac,
                    "cal_info": {
                        "enabled": _cal_enabled,
                        "baselines": {
                            bk: {"delay_ns": v["delay"] * 1e9, "phase_deg": np.degrees(v["phase"])}
                            for bk, v in _cal.items()
                        },
                    } if _cal else None,
                }
                try:
                    corr_plot_queue.put_nowait(corr_frame)
                except (queue.Full, mp.queues.Full):
                    pass

        except Exception as e:
            print(f"Correlation Error: {e}")

    print("Correlate stopped")
