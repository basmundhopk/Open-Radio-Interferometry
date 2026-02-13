#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 13 11:20:56 2026

@author: bretthopkins
"""

import adi
import threading
import numpy as np

from settings import configuration
from fmcomms5_iio import data_read, get_sample_frame, get_all_channel_frames

sdr = adi.fmcomms5.FMComms5()
configuration(sdr)

data_thread = threading.Thread(target=data_read, args=(sdr,), daemon=True)
data_thread.start()

print("SDR streaming started. Reading 1024-sample frames continuously...")

try:
    while True:
        chan_idx, frame = get_sample_frame()
        print(f"Channel {chan_idx}: Received {len(frame)} samples, Mean power: {np.mean(np.abs(frame)**2):.2f}")
        
except KeyboardInterrupt:
    print("\nStopping...")