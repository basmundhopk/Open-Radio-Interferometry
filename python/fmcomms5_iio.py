#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Data acquisition, PFB channelization, and correlation functions

"""

import collections
import multiprocessing as mp
import numpy as np
import queue          # only for queue.Full / queue.Empty
import time

from settings import (QUEUE_SIZE, PFB_ENABLE, P, M, PFB_WINDOW, PFB_FFTSHIFT,
                     FRAME_SIZE, INTEGRATION_COUNT, ANTENNA_POSITIONS_ENU,
                     CHANNEL_TO_ANTENNA, DC_NOTCH_KHZ,
                     OBSERVATION_LATITUDE_DEG, OBSERVATION_LONGITUDE_DEG,
                     OBSERVATION_DECLINATION_DEG, PLOT_INTERVAL)
from pfb_coeffs import generate_win_coeffs_np
from pfb import pfb_channelize_multich_np, db_pwr

# correlation helpers
_triu_i, _triu_j = np.triu_indices(4)
_corr_keys = [f"{i}{j}" for i, j in zip(_triu_i, _triu_j)]


def calc_correlations_numpy(latest):
    combined = latest[_triu_i] * np.conj(latest[_triu_j])
    return {k: combined[idx] for idx, k in enumerate(_corr_keys)}


def create_shared_state():
    """Return a dict of mp-safe queues and events used by every worker."""
    return {
        "raw_queue":        mp.Queue(maxsize=QUEUE_SIZE),
        "pfb_queue":        mp.Queue(maxsize=QUEUE_SIZE),
        "plot_queue":       mp.Queue(maxsize=64),
        "corr_plot_queue":  mp.Queue(maxsize=64),
        "settings_queue":   mp.Queue(maxsize=16),
        "pfb_config_queue": mp.Queue(maxsize=16),
        "corr_config_queue": mp.Queue(maxsize=16),
        "stop_event":       mp.Event(),
    }


def _apply_sdr_config(sdr, cfg, _last={}):
    """Apply a device-settings dict to the SDR hardware.
    Skips writes for values that haven't changed since the last call,
    avoiding expensive AD9361 recalibrations for unchanged attributes.
    """
    mode = cfg.get("gain_control_mode")
    if mode is not None and mode != _last.get("gain_control_mode"):
        sdr.gain_control_mode_chan0 = mode
        sdr.gain_control_mode_chan1 = mode
        sdr.gain_control_mode_chip_b_chan0 = mode
        sdr.gain_control_mode_chip_b_chan1 = mode
        _last["gain_control_mode"] = mode

    g = cfg.get("rx_gain")
    if g is not None and g != _last.get("rx_gain"):
        sdr.rx_hardwaregain_chan0 = g
        sdr.rx_hardwaregain_chan1 = g
        sdr.rx_hardwaregain_chip_b_chan0 = g
        sdr.rx_hardwaregain_chip_b_chan1 = g
        _last["rx_gain"] = g

    lo = cfg.get("rx_lo")
    if lo is not None and lo != _last.get("rx_lo"):
        sdr.rx_lo = lo
        sdr.rx_lo_chip_b = lo
        _last["rx_lo"] = lo

    bw = cfg.get("rx_rf_bandwidth")
    if bw is not None and bw != _last.get("rx_rf_bandwidth"):
        sdr.rx_rf_bandwidth = bw
        sdr.rx_rf_bandwidth_chip_b = bw
        _last["rx_rf_bandwidth"] = bw

    sr = cfg.get("rx_sample_rate")
    if sr is not None and sr != _last.get("rx_sample_rate"):
        sdr.sample_rate = sr
        _last["rx_sample_rate"] = sr

    lb = cfg.get("loopback")
    if lb is not None and lb != _last.get("loopback"):
        sdr.loopback = lb
        sdr.loopback_chip_b = lb
        _last["loopback"] = lb

    buf = cfg.get("rx_buffer_size")
    if buf is not None and buf != _last.get("rx_buffer_size"):
        sdr.rx_buffer_size = buf
        _last["rx_buffer_size"] = buf


def data_read(uri, raw_queue, settings_queue, stop_event, monitor_queues=None):
    """Runs in its own process. Creates the IIO connection from *uri*."""
    import adi
    from settings import configuration

    try:
        sdr = adi.fmcomms5.FMComms5(uri=uri)
        configuration(sdr)
    except Exception as e:
        print(f"data_read: failed to connect to {uri}: {e}")
        return

    print(f"data_read: connected to {uri}  (channels={sdr.rx_enabled_channels})")

    _frame_size = FRAME_SIZE   # mutable local — updated via settings_queue
    dropped = 0
    total = 0
    last_report = time.time()
    t_call = time.perf_counter()

    while not stop_event.is_set():
        # ── check for runtime settings changes from the UI ──
        try:
            while True:
                cfg = settings_queue.get_nowait()
                if "frame_size" in cfg:
                    _frame_size = cfg.pop("frame_size")
                    print(f"data_read: frame_size → {_frame_size}")
                try:
                    _apply_sdr_config(sdr, cfg)
                    if cfg:
                        print(f"data_read: applied config {cfg}")
                except Exception as e:
                    print(f"data_read: config error: {e}")
        except Exception:
            pass

        try:
            t0 = time.perf_counter()
            data = sdr.rx()
            call_ms = (time.perf_counter() - t0) * 1000
            interval_ms = (t0 - t_call) * 1000
            t_call = t0

            if isinstance(data, (list, tuple)):
                num_samples = len(data[0])
                num_frames = num_samples // _frame_size
                for i in range(num_frames):
                    total += 1
                    frame_data = [ch[i * _frame_size:(i + 1) * _frame_size] for ch in data]
                    try:
                        raw_queue.put_nowait(frame_data)
                    except (queue.Full, mp.queues.Full):
                        dropped += 1
            else:
                num_samples = len(data)
                num_frames = num_samples // _frame_size
                for i in range(num_frames):
                    total += 1
                    frame_data = data[i * _frame_size:(i + 1) * _frame_size]
                    try:
                        raw_queue.put_nowait(frame_data)
                    except (queue.Full, mp.queues.Full):
                        dropped += 1
        except Exception as e:
            print(f"Capture Error: {e}")
            break

        now = time.time()
        elapsed = now - last_report
        qd = raw_queue.qsize()
        pct = 100 * dropped / total if total else 0
        sps = (total - dropped) * _frame_size / elapsed if elapsed else 0
        q_str = f"raw={qd}"
        if monitor_queues:
            for qname, qobj in monitor_queues.items():
                try:
                    q_str += f"  {qname}={qobj.qsize()}"
                except Exception:
                    pass
        print(
            f"[stats] queues: {q_str}  |  frames={total}  "
            f"dropped={dropped} ({pct:.1f}%)  rate={sps / 1e3:.1f} kSps  "
            f"rx()={call_ms:.1f}ms  interval={interval_ms:.1f}ms"
        )
        dropped = 0
        total = 0
        last_report = now

    print("Read stopped")


def pfb_process(raw_queue, pfb_queue, plot_queue, stop_event, pfb_config_queue):
    _pfb_h = generate_win_coeffs_np(M, P, window=PFB_WINDOW, normalize=True)
    _frame_buf = collections.deque(maxlen=M)

    _P, _M, _win, _shift, _enabled = P, M, PFB_WINDOW, PFB_FFTSHIFT, PFB_ENABLE
    _dc_notch_khz = DC_NOTCH_KHZ
    _last_plot_t = 0.0
    _plot_interval = PLOT_INTERVAL  # match UI refresh rate

    while not stop_event.is_set():
        try:
            while True:
                cfg = pfb_config_queue.get_nowait()
                _P = cfg.get("P", _P)
                _M = cfg.get("M", _M)
                _win = cfg.get("PFB_WINDOW", _win)
                _shift = cfg.get("PFB_FFTSHIFT", _shift)
                _enabled = cfg.get("PFB_ENABLE", _enabled)
                if "DC_NOTCH_KHZ" in cfg:
                    _dc_notch_khz = cfg["DC_NOTCH_KHZ"]
                    print(f"pfb_process: DC notch → ±{_dc_notch_khz:.1f} kHz")
                _pfb_h = generate_win_coeffs_np(_M, _P, window=_win, normalize=True)
                _frame_buf = collections.deque(maxlen=_M)
                # flush stale frames from raw_queue so old-sized data
                # doesn't cause shape mismatches with the new P
                try:
                    while True:
                        raw_queue.get_nowait()
                except Exception:
                    pass
                print(f"pfb_process: reconfigured P={_P} M={_M} win={_win}")
        except Exception:
            pass

        try:
            raw = raw_queue.get(timeout=0.1)
        except Exception:
            continue

        if _enabled:
            try:
                x4 = np.stack([np.asarray(ch) for ch in raw], axis=0)[:4]
                if x4.shape[0] < 4:
                    raise ValueError(f"Need 4 channels, got {x4.shape[0]}")
                # skip frames that don't match the current P (stale after reconfig)
                if x4.shape[1] != _P:
                    continue
                _frame_buf.append(x4)

                if len(_frame_buf) == _M:
                    x4_window = np.concatenate(list(_frame_buf), axis=1)

                    X4, _ = pfb_channelize_multich_np(
                        x4_window, M=_M, P=_P, window=_win,
                        fftshift=_shift, h=_pfb_h,
                    )

                    latest = X4[:, -1, :]

                    # ── apply DC notch ──
                    if _dc_notch_khz > 0:
                        import settings as _s_pfb_notch
                        _fs_n = _s_pfb_notch.rx_sample_rate
                        bw_khz = (_fs_n / _P) / 1e3
                        nb = int(np.ceil(_dc_notch_khz / bw_khz))
                        if _shift:
                            dc = _P // 2
                            lo_b = max(0, dc - nb)
                            hi_b = min(_P, dc + nb + 1)
                            latest = latest.copy()
                            latest[:, lo_b:hi_b] = 0.0
                        else:
                            latest = latest.copy()
                            latest[:, :nb + 1] = 0.0
                            if nb > 0:
                                latest[:, -nb:] = 0.0

                    spec_db = db_pwr(latest)

                    payload = {
                        "raw": x4_window[:, -_P:],
                        "pfb": spec_db,
                        "latest": latest,
                    }
                    try:
                        pfb_queue.put_nowait(payload)
                    except (queue.Full, mp.queues.Full):
                        pass
                    # IQ + PFB snapshot → UI plot queue  (throttled)
                    _now = time.monotonic()
                    if _now - _last_plot_t >= _plot_interval:
                        _last_plot_t = _now
                        try:
                            plot_queue.put_nowait({
                                "raw": payload["raw"],
                                "pfb": payload["pfb"],
                            })
                        except (queue.Full, mp.queues.Full):
                            pass
            except Exception as e:
                print(f"PFB Error: {e}")
        else:
            try:
                plot_queue.put_nowait(raw)
            except (queue.Full, mp.queues.Full):
                pass

    print("PFB stopped")


def _compute_baselines_wavelengths(antenna_positions, chan_to_ant, freq_hz,
                                    lat_deg, lon_deg, dec_deg):
    """
    Compute (u, v) for every cross-baseline at every frequency channel,
    using the current hour angle derived from Local Sidereal Time.

    Parameters
    ----------
    lat_deg, lon_deg : float   Observatory latitude / longitude in degrees.
    dec_deg          : float   Source declination in degrees.

    Returns
    -------
    uv_dict : dict  {"ij": (u_array, v_array)}  in units of wavelengths
    """
    from datetime import datetime, timezone
    c = 299792458.0

    # ── compute Local Sidereal Time & hour angle ──
    now = datetime.now(timezone.utc)
    # Julian date
    jd = (
        367 * now.year
        - int(7 * (now.year + int((now.month + 9) / 12)) / 4)
        + int(275 * now.month / 9)
        + now.day
        + 1721013.5
        + (now.hour + now.minute / 60.0 + now.second / 3600.0) / 24.0
    )
    T = (jd - 2451545.0) / 36525.0
    # Greenwich Mean Sidereal Time in degrees
    gmst_deg = (280.46061837
                + 360.98564736629 * (jd - 2451545.0)
                + 0.000387933 * T**2
                - T**3 / 38710000.0) % 360.0
    lst_deg = (gmst_deg + lon_deg) % 360.0

    # hour angle in radians
    # RA not specified → assume source is at RA = LST at start (transit)
    # For a real source, RA would be a parameter; here we use LST directly
    # so H = LST - RA.  With RA=0 convention, H = LST.
    # More usefully: set RA = 0 so H simply equals LST, giving continuous rotation.
    H = np.radians(lst_deg)  # hour angle
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

            # ENU → (u, v, w) projection  (Thompson, Moran & Swenson)
            u_m =  sin_H * dN + cos_H * dE
            v_m = -sin_l * cos_H * dN + sin_l * sin_H * dE + cos_l * dU  # ← was missing sin_d/cos_d
            # full expression:
            u_m =  dE * cos_H               - dN * sin_l * sin_H
            v_m =  dE * sin_d * sin_H       + dN * (sin_l * sin_d * cos_H + cos_l * cos_d)
            # Note: w is not needed for 2-D UV plane

            u = u_m / wavelengths
            v = v_m / wavelengths
            uv_dict[f"{i}{j}"] = (u, v)

    return uv_dict


def _save_uv_to_fits(path, u, v, amp, phase, avg_corr, ant_pos, chan_to_ant, int_count):
    """
    Write accumulated UV visibility data to a FITS file.

    The file contains:
      HDU 0 (PRIMARY) – header-only with observation metadata
      HDU 1 (UV_DATA)  – binary table: U, V, AMP, PHASE, VIS_REAL, VIS_IMAG
      HDU 2 (AVG_CORR) – binary table: one column per baseline with averaged
                         complex cross-spectra (if available)
    """
    try:
        from astropy.io import fits
        import settings as _s
        from datetime import datetime, timezone

        # ── PRIMARY header with metadata ──
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

        # ── UV_DATA table ──
        vis = amp * np.exp(1j * phase)
        cols = [
            fits.Column(name="U",        format="D", array=u,            unit="wavelengths"),
            fits.Column(name="V",        format="D", array=v,            unit="wavelengths"),
            fits.Column(name="AMP",      format="D", array=amp),
            fits.Column(name="PHASE",    format="D", array=phase,        unit="rad"),
            fits.Column(name="VIS_REAL", format="D", array=vis.real),
            fits.Column(name="VIS_IMAG", format="D", array=vis.imag),
        ]
        uv_table = fits.BinTableHDU.from_columns(cols, name="UV_DATA")

        # ── AVG_CORR table (averaged cross-spectra per baseline) ──
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


def correlate_process(pfb_queue, corr_plot_queue, stop_event, corr_config_queue):
    """
    Consume PFB output → correlate → average over N integrations → push to UI.

    Sends correlation + UV data to corr_plot_queue.
    """
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
    _GRID_SIZE = 128
    _MAX_SCATTER_PTS = 50_000

    # ── fringe-fitting calibration state ──
    _cal = {}           # per-baseline calibration solutions
    _cal_enabled = False

    # ── DC notch state ──
    _dc_notch_khz = DC_NOTCH_KHZ   # ±kHz to zero around DC

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
                    # Perform fringe fitting on current averaged cross-spectra
                    if _avg:
                        import settings as _s_cal
                        _fs_cal = _s_cal.rx_sample_rate
                        _cal.clear()
                        for bkey, vis in _avg.items():
                            a, b = int(bkey[0]), int(bkey[1])
                            if a == b:
                                continue  # skip auto-correlations
                            # delay spectrum via IFFT
                            delay_spec = np.fft.ifft(vis)
                            n_ch = len(vis)
                            peak_bin = int(np.argmax(np.abs(delay_spec)))
                            # parabolic interpolation for sub-sample accuracy
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
                            # wrap bin to [-N/2, N/2)
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
                    # DC is at center bin
                    dc_idx = _P_notch // 2
                    lo = max(0, dc_idx - n_bins)
                    hi = min(_P_notch, dc_idx + n_bins + 1)
                    latest = latest.copy()
                    latest[:, lo:hi] = 0.0
                else:
                    # DC is at bin 0
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
            # detect size change and reset accumulators
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
                # complete one integration period
                _avg = {k: v / _acc_n for k, v in _acc.items()}
                _acc.clear()
                _acc_n = 0
                _avg_seq += 1

                # compute UV coords for the cross-baselines
                P_cur = latest.shape[1]
                try:
                    # re-import sample rate in case it changed
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
                        _s.OBSERVATION_DECLINATION_DEG,
                    )
                except Exception as e:
                    print(f"UV compute error: {e}")

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
                    for bkey, (u_arr, v_arr) in _uv.items():
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
                        N = _GRID_SIZE
                        _vis = _uv_acc_amp * np.exp(1j * _uv_acc_phase)
                        _uv_max = max(np.abs(_uv_acc_u).max(), np.abs(_uv_acc_v).max(), 1.0) * 1.05
                        _ui = np.round((_uv_acc_u / _uv_max + 1.0) * 0.5 * (N - 1)).astype(int)
                        _vi = np.round((_uv_acc_v / _uv_max + 1.0) * 0.5 * (N - 1)).astype(int)
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
                        _dirty_result = {
                            "dirty_abs": np.abs(_dirty).astype(np.float32),
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
