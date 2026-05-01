"""
Polyphase filter bank channelizer, prototype filter generator, and PFB worker process

  - generate_win_coeffs_np():    windowed-sinc prototype FIR taps of length L = M*P
  - db_mag():                    20·log10 magnitude in dB
  - db_pwr():                    10·log10 power in dB
  - pfb_fir_frontend_np():       polyphase FIR front-end (single channel)
  - pfb_channelize_np():         single-channel PFB channelizer (FIR + FFT)
  - plot_channel_power():        plot average power per channel bin
  - pfb_channelize_multich_np(): 4-channel coherent PFB channelizer
  - pfb_process():               worker that channelizes raw frames and pushes spectra
"""

import collections
import multiprocessing as mp
import queue          # only for queue.Full / queue.Empty
import time

import numpy as np
from open_radio_interferometry.settings import (PFB_ENABLE, P, M, PFB_WINDOW, PFB_FFTSHIFT,
                      DC_NOTCH_KHZ, PLOT_INTERVAL)

# Kaiser window beta parameter (used when window=='kaiser')
KAISER_BETA = 8.6


def generate_win_coeffs_np(M: int = M, P: int = P, window: str = PFB_WINDOW,
                           normalize: bool = True, kaiser_beta: float = KAISER_BETA):
    """Windowed-sinc prototype FIR taps of length L = M*P.

    Supported windows: 'hamming', 'hann'/'hanning', 'blackman-harris'/'blackmanharris',
    'kaiser' (use kaiser_beta to control sidelobe attenuation).
    """
    L = M * P
    n = np.arange(L, dtype=np.float64)
    n0 = (L - 1) / 2.0
    t = n - n0

    win = window.lower().replace("_", "-")

    if win == "hamming":
        w = np.hamming(L)
    elif win in ("hann", "hanning"):
        w = np.hanning(L)
    elif win in ("blackman-harris", "blackmanharris", "blackman_harris"):
        # 4-term Blackman-Harris (Harris, 1978)
        a0, a1, a2, a3 = 0.35875, 0.48829, 0.14128, 0.01168
        k = 2.0 * np.pi * n / (L - 1)
        w = a0 - a1 * np.cos(k) + a2 * np.cos(2 * k) - a3 * np.cos(3 * k)
    elif win == "kaiser":
        w = np.kaiser(L, kaiser_beta)
    else:
        raise ValueError(
            "window must be one of: 'hamming', 'hann', 'blackman-harris', 'kaiser'"
        )

    # Ideal lowpass (normalized cutoff ~ 1/P of Nyquist)
    # cycles/sample fc = (1/P)*0.5 = 1/(2P)
    # impulse response: h = 2*fc*sinc(2*fc*(n-n0)) = (1/P)*sinc((n-n0)/P)
    h_ideal = (1.0 / P) * np.sinc(t / P)

    h = w * h_ideal

    if normalize:
        h /= np.sum(h)

    return h


def db_mag(x, eps=1e-12):
    x = np.asarray(x)
    return 20*np.log10(np.abs(x) + eps)

def db_pwr(x, eps=1e-12):
    x = np.asarray(x)
    return 10*np.log10(np.abs(x)**2 + eps)


def pfb_fir_frontend_np(x, h, M: int, P: int):
    x = np.asanyarray(x)
    h = np.asanyarray(h)

    L = M * P
    if h.size != L:
        raise ValueError(f"h must have length M*P = {L}, got {h.size}")
    # Split input into blocks of P samples (time index n')
    B = x.size // P
    x = x[:B * P]
    x_blocks = x.reshape(B, P).T          # shape (P, B)  => x_p[p, n']
    h_poly   = h.reshape(M, P).T          # shape (P, M)  => h_p[p, m]

    n_frames = B - M + 1
    if n_frames <= 0:
        raise ValueError("Not enough data: need at least M blocks of P samples.")

    y = np.zeros((n_frames, P), dtype=np.complex128)

    # Implements: y_p[n'] = sum_{m=0..M-1} h_p[m] * x_p[n'+m] (forward form)
    # Equivalent to textbook x_p[n'-m] with reversed tap indexing.
    for t in range(n_frames):
        seg = x_blocks[:, t:t+M]          # (P, M)
        y[t, :] = np.sum(seg * h_poly, axis=1)

    return y


def pfb_channelize_np(x, M: int, P: int, window="hamming", fftshift=False, do_plot=False):
    h = generate_win_coeffs_np(M, P, window=window, normalize=True)

    y = pfb_fir_frontend_np(x, h, M, P)
    X = np.fft.fft(y, axis=1)

    if fftshift:
        X = np.fft.fftshift(X, axes=1)

    return X, h

def plot_channel_power(X, title="Average channel power"):
    # X shape: (frames, P)
    import pyqtgraph as pg
    from PyQt5.QtWidgets import QApplication
    pwr = np.mean(np.abs(X)**2, axis=0)
    app = QApplication.instance() or QApplication([])
    win = pg.plot(pwr, title=title, pen="y")
    win.setLabel("bottom", "Bin k")
    win.setLabel("left", "Power")
    win.showGrid(x=True, y=True, alpha=0.3)
    app.exec_()


def pfb_channelize_multich_np(x4, M: int = 4, P: int = 1024, window="hamming", fftshift=False, h=None):
    x4 = np.asarray(x4)

    # normalize shape to (4, N)
    if x4.ndim != 2:
        raise ValueError("x4 must be 2D (4,N) or (N,4)")

    if x4.shape[0] == 4:
        pass             # already (4, N)
    elif x4.shape[1] == 4:
        x4 = x4.T         # convert (N, 4) -> (4, N)
    else:
        raise ValueError("x4 must have 4 channels on one axis")
    if h is None:
        h = generate_win_coeffs_np(M, P, window=window, normalize=True)

    X_all = []
    for ch in range(4):
        y = pfb_fir_frontend_np(x4[ch], h, M, P)
        X = np.fft.fft(y, axis=1)
        if fftshift:
            X = np.fft.fftshift(X, axes=1)
        X_all.append(X)

    return np.stack(X_all, axis=0), h   # (4, frames, P)


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