"""
Main SDR data acquisition and visualization application.

All heavy work runs in separate processes (own GIL each):
  - data_read:         SDR capture  (creates IIO connection internally)
  - pfb_process:       PFB channelization
  - correlate_process: cross-/auto-correlation

The Qt UI runs on the main process / main thread.
"""
import multiprocessing as mp
import signal
from fmcomms5_iio import create_shared_state, data_read, pfb_process, correlate_process
from ui import run_ui

SDR_URI = "ip:192.168.1.2"

if __name__ == "__main__":
    mp.set_start_method("spawn", force=True)

    shared = create_shared_state()

    read_proc = mp.Process(
        target=data_read,
        args=(SDR_URI, shared["raw_queue"], shared["settings_queue"],
              shared["stop_event"]),
        daemon=True,
    )
    read_proc.start()

    pfb_proc = mp.Process(
        target=pfb_process,
        args=(shared["raw_queue"], shared["pfb_queue"], shared["plot_queue"],
              shared["stop_event"], shared["pfb_config_queue"]),
        daemon=True,
    )
    pfb_proc.start()

    corr_proc = mp.Process(
        target=correlate_process,
        args=(shared["pfb_queue"], shared["plot_queue"], shared["stop_event"]),
        daemon=True,
    )
    corr_proc.start()

    signal.signal(signal.SIGINT,  lambda *_: shared["stop_event"].set())
    signal.signal(signal.SIGTERM, lambda *_: shared["stop_event"].set())

    try:
        run_ui(num_channels=4, shared=shared)
    except KeyboardInterrupt:
        pass
    finally:
        print("\nStopping capture.")
        shared["stop_event"].set()

    read_proc.join(timeout=2)
    pfb_proc.join(timeout=2)
    corr_proc.join(timeout=2)
    print("Capture complete.")