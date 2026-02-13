#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 9 11:11:02 2026

@author: bretthopkins
"""

import numpy as np
from queue import Queue
from threading import Thread, Lock

data_queue = Queue(maxsize=100)
sample_buffer = {0: [], 1: [], 2: [], 3: []}
buffer_lock = Lock()
FRAME_SIZE = 1024

def data_read(sdr):
    while True:
        try:
            data_rx = sdr.rx()
            with buffer_lock:
                for chan_idx, chan_data in enumerate(data_rx):
                    sample_buffer[chan_idx].extend(chan_data)
                    
                    while len(sample_buffer[chan_idx]) >= FRAME_SIZE:
                        frame = np.array(sample_buffer[chan_idx][:FRAME_SIZE], dtype=np.complex64)
                        sample_buffer[chan_idx] = sample_buffer[chan_idx][FRAME_SIZE:]
                        
                        data_queue.put((chan_idx, frame))
                        
        except Exception as e:
            print(f"Error in data_read: {e}")
            continue

def get_sample_frame():
    return data_queue.get()

def get_all_channel_frames():
    frames = {}
    for _ in range(4):
        chan_idx, frame = data_queue.get()
        frames[chan_idx] = frame
    return frames