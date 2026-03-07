"""
Settings File for Open Radio Interferometry

"""

#Default settings loaded on startup. 

# IIO Settings
FRAME_SIZE = 4096
QUEUE_SIZE = 100

# PFB Settings
P = 4096                   # Size of FFT
M = 4                      # taps-per-branch
PFB_WINDOW = "hamming"     # need to implement more window types if desired, currently only hamming and hann/hanning  
PFB_FFTSHIFT = True        # center DC in plot
PFB_ENABLE = True          # enable PFB channelizer (set to False to plot raw FFT instead)

# FMCOMMS5 Settings
filter_fir = '' #Filepath to FIR filter file
gain_control_mode = 'fast_attack' #Receive gain. Options are: slow_attack, fast_attack, manual
loopback = 0 #Options are: 0 (Disable), 1 (Digital), 2 (RF)
rx_gain = 0 #Only applicable when gain_control_mode is set to ‘manual’
rx_lo = 1420400000 #Carrier frequency
rx_rf_bandwidth = 10000000 #Filter bandwidth
rx_sample_rate = 521000 #Transceiver sample rate
rx_buffer = FRAME_SIZE #Buffer size of rx samples
rx_output_type = 'raw' #Options are: 'raw' or 'SI'
rx_channels = [0, 1, 2, 3]
rx_annotated = False

# UI Settings
PLOT_INTERVAL = 0.2 #Seconds between plot updates


def configuration(sdr):
    #chip a
    sdr.gain_control_mode_chan0 = gain_control_mode
    sdr.gain_control_mode_chan1 = gain_control_mode
    sdr.loopback = loopback
    sdr.rx_hardwaregain_chan0 = rx_gain
    sdr.rx_hardwaregain_chan1 = rx_gain
    sdr.rx_lo = rx_lo
    sdr.rx_rf_bandwidth = rx_rf_bandwidth
    
    #chip b
    sdr.gain_control_mode_chip_b_chan0 = gain_control_mode
    sdr.gain_control_mode_chip_b_chan1 = gain_control_mode
    sdr.loopback_chip_b = loopback
    sdr.rx_hardwaregain_chip_b_chan0 = rx_gain
    sdr.rx_hardwaregain_chip_b_chan1 = rx_gain
    sdr.rx_lo_chip_b = rx_lo
    sdr.rx_rf_bandwidth_chip_b = rx_rf_bandwidth
    
    #general settings
    
    #sdr.filter = filter_fir
    sdr.sample_rate = rx_sample_rate
    sdr.rx_buffer_size = rx_buffer
    sdr.rx_output_type = rx_output_type
    sdr.rx_annotated = rx_annotated
    sdr.rx_enabled_channels = rx_channels
    
    # Print all configuration values
    print("\n=== FMComms5 Configuration ===")
    print("\n--- Chip A ---")
    print(f"  gain_control_mode_chan0: {sdr.gain_control_mode_chan0}")
    print(f"  gain_control_mode_chan1: {sdr.gain_control_mode_chan1}")
    print(f"  loopback: {sdr.loopback}")
    print(f"  rx_hardwaregain_chan0: {sdr.rx_hardwaregain_chan0} dB")
    print(f"  rx_hardwaregain_chan1: {sdr.rx_hardwaregain_chan1} dB")
    print(f"  rx_lo: {sdr.rx_lo} Hz ({sdr.rx_lo/1e6:.3f} MHz)")
    print(f"  rx_rf_bandwidth: {sdr.rx_rf_bandwidth} Hz ({sdr.rx_rf_bandwidth/1e6:.1f} MHz)")
    
    print("\n--- Chip B ---")
    print(f"  gain_control_mode_chip_b_chan0: {sdr.gain_control_mode_chip_b_chan0}")
    print(f"  gain_control_mode_chip_b_chan1: {sdr.gain_control_mode_chip_b_chan1}")
    print(f"  loopback_chip_b: {sdr.loopback_chip_b}")
    print(f"  rx_hardwaregain_chip_b_chan0: {sdr.rx_hardwaregain_chip_b_chan0} dB")
    print(f"  rx_hardwaregain_chip_b_chan1: {sdr.rx_hardwaregain_chip_b_chan1} dB")
    print(f"  rx_lo_chip_b: {sdr.rx_lo_chip_b} Hz ({sdr.rx_lo_chip_b/1e6:.3f} MHz)")
    print(f"  rx_rf_bandwidth_chip_b: {sdr.rx_rf_bandwidth_chip_b} Hz ({sdr.rx_rf_bandwidth_chip_b/1e6:.1f} MHz)")
    
    print("\n--- General Settings ---")
    print(f"  sample_rate: {sdr.sample_rate} Hz ({sdr.sample_rate/1e6:.3f} MHz)")
    print(f"  rx_buffer_size: {sdr.rx_buffer_size} samples")
    print(f"  rx_output_type: {sdr.rx_output_type}")
    print(f"  rx_annotated: {sdr.rx_annotated}")
    print(f"  rx_enabled_channels: {sdr.rx_enabled_channels}")
    print("==============================\n")