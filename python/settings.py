#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 11 11:11:02 2026

@author: bretthopkins
"""

filter_fir = '' #Filepath to FIR filter file
gain_control_mode = 'manual' #Receive gain. Options are: slow_attack, fast_attack, manual
loopback = 0 #Options are: 0 (Disable), 1 (Digital), 2 (RF)
rx_gain = 0 #Only applicable when gain_control_mode is set to ‘manual’
rx_lo = 1.4204 * 10**9 #Carrier frequency
rx_rf_bandwidth = 10 * 10**6 #Filter bandwidth
rx_sample_rate = 10 * 10**6 #Transceiver sample rate
rx_buffer = 1024 * 256 #Buffer size of rx samples
rx_output_type = 'ndarray'
rx_channels = [0, 1, 2, 3]
rx_annotated = True


def configuration(sdr):
    sdr.filter = filter_fir
    sdr.gain_control_mode_chipb_chan0 = gain_control_mode
    sdr.gain_control_mode_chipb_chan1 = gain_control_mode
    sdr.loopback_chip_b = loopback
    sdr.rx_hardwaregain_chip_b_chan0 = rx_gain
    sdr.rx_hardwaregain_chip_b_chan1 = rx_gain
    sdr.rx_lo_chip_b = rx_lo
    sdr.rx_rf_bandwidth_chip_b = rx_rf_bandwidth
    sdr.sample_rate = rx_sample_rate
    sdr.rx_buffer_size = rx_buffer
    sdr.rx_output_size = rx_output_type
    sdr.rx_annotated = rx_annotated
    sdr.rx_enabled_channels = rx_channels