#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 9 11:11:02 2026

@author: bretthopkins
"""

import numpy as np
import queue
import threading
import time
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from settings import QUEUE_SIZE, PFB_ENABLE, PFB_P, PFB_M, PFB_WINDOW, PFB_FFTSHIFT
from pfb_demo import generate_win_coeffs_np, pfb_channelize_multich_np, db_pwr

data_queue = queue.Queue(maxsize=QUEUE_SIZE)
stop_event = threading.Event()

# Shared slot for the latest frame to be plotted
_plot_lock = threading.Lock()
_latest_frame = None

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

_pfb_h = generate_win_coeffs_np(PFB_M, PFB_P, window=PFB_WINDOW, normalize=True)

def data_read(sdr):
    dropped_warnings = 0
    
    while not stop_event.is_set():
        try:
            data = sdr.rx()
            data_queue.put(data, block=False)            
        except queue.Full:
            print("Dropping frame!!!!!!!!!!!")
            dropped_warnings += 1
        except Exception as e:
            print(f"Capture Error: {e}")
            break
            
    print("Read stopped")

def data_process():
    global _latest_frame
    last_plot_time = 0.0
    PLOT_INTERVAL = 0.05  # seconds

    while not stop_event.is_set():
        try:
            frame = data_queue.get(timeout=0.1)
            data_queue.task_done()
        except queue.Empty:
            continue
        except Exception as e:
            print(f"Processing Error: {e}")
            break

        now = time.time()
        if now - last_plot_time >= PLOT_INTERVAL:
            if PFB_ENABLE:
                try:
                    x4 = _to_4xN(frame)  # (4, N)

                    # PFB: returns (4, n_frames, P)
                    X4, _ = pfb_channelize_multich_np(
                        x4, M=PFB_M, P=PFB_P, window=PFB_WINDOW, fftshift=PFB_FFTSHIFT, h=_pfb_h
                    )

                    latest = X4[:, -1, :]          # (4, P)
                    spec_db = db_pwr(latest)       # (4, P)

                    with _plot_lock:
                        _latest_frame = spec_db    # now latest_frame is spectrum
                except Exception as e:
                    print(f"PFB Error: {e}")
            else:
                with _plot_lock:
                    _latest_frame = frame          # raw IQ

            last_plot_time = now

def run_plot_loop(num_channels=4):
    fig, axes = plt.subplots(num_channels, 1, figsize=(12, 8), sharex=True)

    i_lines = []
    q_lines = []
    for i, ax in enumerate(axes):
        line_i, = ax.plot([], [], label='I', alpha=0.8)
        line_q, = ax.plot([], [], label='Q', alpha=0.8)
        i_lines.append(line_i)
        q_lines.append(line_q)
        ax.set_ylabel(f'Ch {i}')
        ax.legend(loc='upper right', fontsize=8)
        ax.grid(True, alpha=0.3)

    axes[-1].set_xlabel('Sample')
    fig.suptitle('Frame Capture')
    plt.tight_layout()

    def update(_frame_number):
        global _latest_frame
        with _plot_lock:
            frame = _latest_frame
            _latest_frame = None  # consume it

        if frame is None:
            return i_lines + q_lines

        for i in range(min(len(frame), num_channels)):
            samples = frame[i]
            x = np.arange(len(samples))
            i_lines[i].set_data(x, np.real(samples))
            q_lines[i].set_data(x, np.imag(samples))
            axes[i].relim()
            axes[i].autoscale_view()

        fig.suptitle(f'Frame Capture — {time.strftime("%H:%M:%S")}')
        return i_lines + q_lines

    _anim = FuncAnimation(fig, update, interval=50, blit=False, cache_frame_data=False)
    plt.show()  # blocks on main thread
