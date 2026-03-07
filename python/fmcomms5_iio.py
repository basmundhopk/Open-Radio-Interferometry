#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 9 11:11:02 2026

@author: bretthopkins
"""

import collections
import numpy as np
import queue
import threading
import time
from settings import QUEUE_SIZE, PFB_ENABLE, P, M, PFB_WINDOW, PFB_FFTSHIFT, FRAME_SIZE
from pfb_coeffs import generate_win_coeffs_np
from pfb import pfb_channelize_multich_np, db_pwr

data_queue = queue.Queue(maxsize=QUEUE_SIZE)
stop_event = threading.Event()

# Shared slot for the latest frame to be plotted
_plot_lock = threading.Lock()
latest_frame = None

def _to_4xN(frame):
    """
    pyadi-iio often returns list/tuple of arrays for multi-channel.
    Convert to np.ndarray with shape (4, N).
    """
    
    if isinstance(frame, (list, tuple)):
        x = np.stack([np.asarray(ch) for ch in frame], axis=0)
    else:
        x = np.asarray(frame)
        if x.ndim == 1:
            x = x[None, :]  # (1, N)

    if x.shape[0] < 4:
        raise ValueError(f"Need 4 channels, got {x.shape[0]}")
    return x[:4]

_pfb_h = generate_win_coeffs_np(M, P, window=PFB_WINDOW, normalize=True)

def data_read(sdr):
    dropped = 0
    total = 0
    last_report = time.time()
    t_call = time.perf_counter()        # time of last sdr.rx() start

    while not stop_event.is_set():
        try:
            t0 = time.perf_counter()
            data = sdr.rx()
            call_ms = (time.perf_counter() - t0) * 1000       # time inside sdr.rx()
            interval_ms = (t0 - t_call) * 1000                # time since last call started
            t_call = t0
            total += 1
            data_queue.put(data, block=False)
        except queue.Full:
            dropped += 1
            total += 1
            call_ms = 0
            interval_ms = 0
        except Exception as e:
            print(f"Capture Error: {e}")
            break

        now = time.time()
        if now - last_report >= 1.0:
            elapsed = now - last_report
            qd = data_queue.qsize()
            pct = 100 * dropped / total if total else 0
            sps = (total - dropped) * FRAME_SIZE / elapsed
            print(f"[stats] queue={qd}/{QUEUE_SIZE}  frames={total}  dropped={dropped} ({pct:.1f}%)  "
                  f"rate={sps/1e3:.1f} kSps  rx()={call_ms:.1f}ms  interval={interval_ms:.1f}ms")
            dropped = 0
            total = 0
            last_report = now

    print("Read stopped")

def data_process():
    global latest_frame

    # Sliding window: holds the last M raw (4, N) frames
    _frame_buf = collections.deque(maxlen=M)

    while not stop_event.is_set():
        try:
            raw = data_queue.get(timeout=0.1)
            if PFB_ENABLE:
                try:
                    x4 = _to_4xN(raw)               # (4, N)
                    _frame_buf.append(x4)

                    if len(_frame_buf) == M:
                        # Concatenate M frames → (4, M*N) for PFB input
                        x4_window = np.concatenate(list(_frame_buf), axis=1)  # (4, M*N)

                        # PFB: returns (4, n_frames, P)
                        X4, _ = pfb_channelize_multich_np(
                            x4_window, M=M, P=P, window=PFB_WINDOW, fftshift=PFB_FFTSHIFT, h=_pfb_h
                        )

                        latest = X4[:, -1, :]       # (4, P) — last output frame
                        spec_db = db_pwr(latest)    # (4, P)

                        with _plot_lock:
                            latest_frame = {'raw': x4, 'pfb': spec_db}
                except Exception as e:
                    print(f"PFB Error: {e}")
            else:
                with _plot_lock:
                    latest_frame = raw

            data_queue.task_done()
        except queue.Empty:
            continue
        except Exception as e:
            print(f"Processing Error: {e}")
            break
