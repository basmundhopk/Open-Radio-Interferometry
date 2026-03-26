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

# Generate combinations matrix cache
_triu_i, _triu_j = np.triu_indices(4)
_corr_keys = [f"{i}{j}" for i, j in zip(_triu_i, _triu_j)]

def calc_correlations_numpy(latest):
    # vectorized SIMD hardware-acceleration via numpy
    combined = latest[_triu_i] * np.conj(latest[_triu_j])
    return {k: combined[idx] for idx, k in enumerate(_corr_keys)}

raw_queue = queue.Queue(maxsize=QUEUE_SIZE)
pfb_queue = queue.Queue(maxsize=QUEUE_SIZE)
stop_event = threading.Event()

# Shared slot for the latest frame to be plotted
_plot_lock = threading.Lock()
latest_frame = None

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

            if isinstance(data, (list, tuple)):
                num_samples = len(data[0])
                num_frames = num_samples // FRAME_SIZE
                for i in range(num_frames):
                    total += 1
                    frame_data = [ch[i*FRAME_SIZE : (i+1)*FRAME_SIZE] for ch in data]
                    try:
                        raw_queue.put(frame_data, block=False)
                    except queue.Full:
                        dropped += 1
            else:
                num_samples = len(data)
                num_frames = num_samples // FRAME_SIZE
                for i in range(num_frames):
                    total += 1
                    frame_data = data[i*FRAME_SIZE : (i+1)*FRAME_SIZE]
                    try:
                        raw_queue.put(frame_data, block=False)
                    except queue.Full:
                        dropped += 1
        except Exception as e:
            print(f"Capture Error: {e}")
            break

        now = time.time()
        elapsed = now - last_report
        qd = raw_queue.qsize()
        pct = 100 * dropped / total if total else 0
        sps = (total - dropped) * FRAME_SIZE / elapsed
        print(f"[stats] queue={qd}/{QUEUE_SIZE}  frames={total}  dropped={dropped} ({pct:.1f}%)  "
                f"rate={sps/1e3:.1f} kSps  rx()={call_ms:.1f}ms  interval={interval_ms:.1f}ms")
        dropped = 0
        total = 0
        last_report = now

    print("Read stopped")

def pfb_process():
    global latest_frame

    _frame_buf = collections.deque(maxlen=M)

    while not stop_event.is_set():
        try:
            raw = raw_queue.get(timeout=0.1)
            if PFB_ENABLE:
                try:
                    x4 = np.stack([np.asarray(ch) for ch in raw], axis=0)[:4]   # (4, N)
                    if x4.shape[0] < 4:
                        raise ValueError(f"Need 4 channels, got {x4.shape[0]}")
                    _frame_buf.append(x4)

                    if len(_frame_buf) == M:
                        # Concatenate M frames → (4, M*N) for PFB input
                        x4_window = np.concatenate(list(_frame_buf), axis=1)    # (4, M*N)

                        # PFB: returns (4, n_frames, P)
                        X4, _ = pfb_channelize_multich_np(
                            x4_window, M=M, P=P, window=PFB_WINDOW, fftshift=PFB_FFTSHIFT, h=_pfb_h
                        )

                        latest = X4[:, -1, :]       # (4, P) — last output frame
                        spec_db = db_pwr(latest)    # (4, P)

                        try:
                            pfb_queue.put({'raw': x4_window[:, -FRAME_SIZE:], 'pfb': spec_db, 'latest': latest}, block=False)
                        except queue.Full:
                            pass
                except Exception as e:
                    print(f"PFB Error: {e}")
            else:
                with _plot_lock:
                    latest_frame = raw

            raw_queue.task_done()
        except queue.Empty:
            continue
        except Exception as e:
            print(f"PFB Processing Error: {e}")
            break

def correlate_process():
    global latest_frame

    while not stop_event.is_set():
        try:
            pfb_data = pfb_queue.get(timeout=0.1)
            
            latest = pfb_data['latest']
            # Calculate auto- and cross-correlations (10 total combinations for 4 channels)
            correlations = {}
            for i in range(4):
                for j in range(i, 4):
                    correlations[f'{i}{j}'] = latest[i] * np.conj(latest[j])

            with _plot_lock:
                latest_frame = {'raw': pfb_data['raw'], 'pfb': pfb_data['pfb'], 'correlations': correlations}

            pfb_queue.task_done()
        except queue.Empty:
            continue
        except Exception as e:
            print(f"Correlation Processing Error: {e}")
            break
