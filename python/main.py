"""
Main SDR data acquisition and visualization application.

"""
import adi
import threading
import signal
import time
from settings import configuration
from fmcomms5_iio import data_read, data_process, stop_event
from plot import run_plot_loop

try:
    sdr = adi.fmcomms5.FMComms5()
    configuration(sdr)
except Exception as e:
    print(f"Failed to connect: {e}")
    exit(1)

process_thread = threading.Thread(target=data_process, daemon=True)
process_thread.start()

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
process_thread.join(timeout=2)
print("Capture complete.")