#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Data acquisition, PFB channelization, and correlation pipeline.

Architecture
------------
- data_read()         → **Process**  (creates its own IIO connection)
- pfb_process()       → **Process**  (heavy NumPy — own GIL)
- correlate_process() → **Process**  (own GIL)

All inter-worker communication uses multiprocessing. Queue / Event.
Device-settings changes from the UI are sent via settings_queue.

@author: bretthopkins
"""

import collections
import multiprocessing as mp
import numpy as np
import queue          # only for queue.Full / queue.Empty
import time

from settings import QUEUE_SIZE, PFB_ENABLE, P, M, PFB_WINDOW, PFB_FFTSHIFT, FRAME_SIZE
from pfb_coeffs import generate_win_coeffs_np
from pfb import pfb_channelize_multich_np, db_pwr

# ── correlation helpers ───────────────────────────────────────
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
        "settings_queue":   mp.Queue(maxsize=16),
        "pfb_config_queue": mp.Queue(maxsize=16),
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


def data_read(uri, raw_queue, settings_queue, stop_event):
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
        print(
            f"[stats] queue={qd}/{QUEUE_SIZE}  frames={total}  "
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

    while not stop_event.is_set():
        try:
            while True:
                cfg = pfb_config_queue.get_nowait()
                _P = cfg.get("P", _P)
                _M = cfg.get("M", _M)
                _win = cfg.get("PFB_WINDOW", _win)
                _shift = cfg.get("PFB_FFTSHIFT", _shift)
                _enabled = cfg.get("PFB_ENABLE", _enabled)
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
                _frame_buf.append(x4)

                if len(_frame_buf) == _M:
                    x4_window = np.concatenate(list(_frame_buf), axis=1)

                    X4, _ = pfb_channelize_multich_np(
                        x4_window, M=_M, P=_P, window=_win,
                        fftshift=_shift, h=_pfb_h,
                    )

                    latest = X4[:, -1, :]
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
            except Exception as e:
                print(f"PFB Error: {e}")
        else:
            try:
                plot_queue.put_nowait(raw)
            except (queue.Full, mp.queues.Full):
                pass

    print("PFB stopped")


def correlate_process(pfb_queue, plot_queue, stop_event):
    while not stop_event.is_set():
        try:
            pfb_data = pfb_queue.get(timeout=0.1)
        except Exception:
            continue

        try:
            latest = pfb_data["latest"]
            correlations = {}
            for i in range(4):
                for j in range(i, 4):
                    correlations[f"{i}{j}"] = latest[i] * np.conj(latest[j])

            frame = {
                "raw": pfb_data["raw"],
                "pfb": pfb_data["pfb"],
                "correlations": correlations,
            }
            try:
                plot_queue.put_nowait(frame)
            except (queue.Full, mp.queues.Full):
                pass
        except Exception as e:
            print(f"Correlation Error: {e}")

    print("Correlate stopped")
