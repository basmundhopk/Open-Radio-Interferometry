#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Standalone matplotlib animation plot loop (alternative to PyQt UI).

  - run_plot_loop(): live plot of IQ + PFB + correlations using FuncAnimation
"""

import numpy as np
import time
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from settings import PLOT_INTERVAL, PFB_ENABLE, P, rx_sample_rate, PFB_FFTSHIFT
from fmcomms5_iio import _plot_lock, latest_frame as _lf


def run_plot_loop(num_channels=4):
    import fmcomms5_iio as _iio

    corr_keys = ['00', '01', '02', '03', '11', '12', '13', '22', '23', '33']
    if PFB_ENABLE:
        fig, all_axes = plt.subplots(4, 5, figsize=(24, 10))
        iq_axes  = all_axes[:, 0]   # left column  — raw IQ
        pfb_axes = all_axes[:, 1]   # right column — PFB spectrum
        
        # Flattened grid for correlations
        c_axes = [all_axes[0, 2], all_axes[1, 2], all_axes[2, 2], all_axes[3, 2],
                  all_axes[0, 3], all_axes[1, 3], all_axes[2, 3],
                  all_axes[0, 4], all_axes[1, 4], all_axes[2, 4]]
        
        all_axes[3, 3].axis('off')
        all_axes[3, 4].axis('off')
        corr_axes_dict = dict(zip(corr_keys, c_axes))
    else:
        fig, all_axes = plt.subplots(num_channels, 1, figsize=(12, 8), sharex=True)
        iq_axes  = all_axes
        pfb_axes = None
        corr_axes_dict = {}

    i_lines, q_lines, pfb_lines = [], [], []
    corr_lines = {}

    for i, ax in enumerate(iq_axes):
        line_i, = ax.plot([], [], label='I', alpha=0.8)
        line_q, = ax.plot([], [], label='Q', alpha=0.8)
        i_lines.append(line_i)
        q_lines.append(line_q)
        ax.set_ylabel(f'Ch {i}')
        ax.legend(loc='upper right', fontsize=8)
        ax.grid(True, alpha=0.3)
    iq_axes[-1].set_xlabel('Sample')

    if PFB_ENABLE:
        # Frequency axis in Hz: bin k -> k * fs/P, shifted if fftshift
        freq_axis = np.fft.fftfreq(P, d=1.0 / rx_sample_rate)
        if PFB_FFTSHIFT:
            freq_axis = np.fft.fftshift(freq_axis)
        freq_axis_mhz = freq_axis / 1e6

        for i, ax in enumerate(pfb_axes):
            line_p, = ax.plot([], [], color='tab:green', alpha=0.8)
            pfb_lines.append(line_p)
            ax.set_ylabel(f'Ch {i} (dB)')
            ax.grid(True, alpha=0.3)
        pfb_axes[-1].set_xlabel('Frequency (MHz)')
        pfb_axes[0].set_title('PFB Spectrum')
        iq_axes[0].set_title('Raw IQ')
        
        for key in corr_keys:
            ax = corr_axes_dict[key]
            line_c, = ax.plot([], [], color='tab:purple', alpha=0.8)
            corr_lines[key] = line_c
            ax.set_ylabel(f'Corr {key} (dB)')
            ax.grid(True, alpha=0.3)
        corr_axes_dict['00'].set_title('Correlations')
        corr_axes_dict['33'].set_xlabel('Frequency (MHz)')
        corr_axes_dict['13'].set_xlabel('Frequency (MHz)')
        corr_axes_dict['23'].set_xlabel('Frequency (MHz)')

    fig.suptitle('Frame Capture')
    plt.tight_layout()

    all_lines = i_lines + q_lines + pfb_lines + list(corr_lines.values())

    def update(_frame_number):
        with _iio._plot_lock:
            frame = _iio.latest_frame
            _iio.latest_frame = None  # consume it

        if frame is None:
            return all_lines

        raw = frame['raw'] if PFB_ENABLE else frame
        pfb = frame['pfb'] if PFB_ENABLE else None

        for i in range(min(raw.shape[0] if hasattr(raw, 'shape') else len(raw), num_channels)):
            samples = raw[i]
            x = np.arange(len(samples))
            i_lines[i].set_data(x, np.real(samples))
            q_lines[i].set_data(x, np.imag(samples))
            iq_axes[i].relim()
            iq_axes[i].autoscale_view()

        if PFB_ENABLE and pfb is not None:
            for i in range(min(pfb.shape[0], num_channels)):
                pfb_lines[i].set_data(freq_axis_mhz, pfb[i])
                pfb_axes[i].relim()
                pfb_axes[i].autoscale_view()
            
            correlations = frame.get('correlations', {})
            for key in corr_keys:
                if key in correlations:
                    # plot magnitude in dB
                    corr_db = 10 * np.log10(np.abs(correlations[key]) + 1e-12)
                    corr_lines[key].set_data(freq_axis_mhz, corr_db)
                    corr_axes_dict[key].relim()
                    corr_axes_dict[key].autoscale_view()

        fig.suptitle(f'Frame Capture — {time.strftime("%H:%M:%S")}')
        return all_lines

    _anim = FuncAnimation(fig, update, interval=int(PLOT_INTERVAL * 1000), blit=False, cache_frame_data=False)
    plt.show()  # blocks on main thread
