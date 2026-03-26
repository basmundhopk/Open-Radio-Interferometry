"""
Main SDR data acquisition and visualization application.

"""
import adi
import threading
import signal
import time
from settings import configuration
from fmcomms5_iio import data_read, pfb_process, correlate_process, stop_event
from plot import run_plot_loop

try:
    sdr = adi.fmcomms5.FMComms5(uri="ip:192.168.1.2")
    configuration(sdr)
except Exception as e:
    print(f"Failed to connect: {e}")
    exit(1)

pfb_thread = threading.Thread(target=pfb_process, daemon=True)
pfb_thread.start()

correlate_thread = threading.Thread(target=correlate_process, daemon=True)
correlate_thread.start()

read_thread = threading.Thread(target=data_read, args=(sdr,), daemon=True)
read_thread.start()

signal.signal(signal.SIGINT,  lambda *_: stop_event.set())
signal.signal(signal.SIGTERM, lambda *_: stop_event.set())

try:
    run_plot_loop(num_channels=len(sdr.rx_enabled_channels))
except KeyboardInterrupt:
    pass
finally:
    print("\nStopping capture.")
    stop_event.set()

read_thread.join(timeout=2)
pfb_thread.join(timeout=2)
correlate_thread.join(timeout=2)
print("Capture complete.")