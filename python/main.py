"""
Main SDR data acquisition and visualization file.

"""
import multiprocessing as mp
import signal
from fmcomms5_iio import create_shared_state, data_read
from pfb import pfb_process
from correlator import correlate_process
from ui import run_ui, load_persistent_configs

SDR_URI = "ip:192.168.1.2"

if __name__ == "__main__":
    mp.set_start_method("spawn", force=True)

    shared = create_shared_state()

    # pre-load last session's settings (QSettings)
    try:
        device_cfg, pfb_cfg, corr_cfg, frame_size = load_persistent_configs()
        shared["settings_queue"].put({"frame_size": frame_size,
                                      "rx_buffer_size": frame_size * 100,
                                      **device_cfg})
        shared["pfb_config_queue"].put(pfb_cfg)
        shared["corr_config_queue"].put(corr_cfg)
        print(f"main: pre-queued persistent settings  "
              f"(LO={device_cfg['rx_lo']/1e6:.3f} MHz, "
              f"BW={device_cfg['rx_rf_bandwidth']/1e6:.1f} MHz, "
              f"SR={device_cfg['rx_sample_rate']/1e6:.3f} MSps, "
              f"gain={device_cfg['rx_gain']} dB [{device_cfg['gain_control_mode']}], "
              f"P={pfb_cfg['P']}, M={pfb_cfg['M']}, "
              f"intcount={corr_cfg['integration_count']}, "
              f"grid={corr_cfg['ifft_grid_size']})")
    except Exception as e:
        print(f"main: could not pre-queue persistent settings: {e}")

    monitor_queues = {
        "pfb": shared["pfb_queue"],
        "plot": shared["plot_queue"],
        "corr_plot": shared["corr_plot_queue"],
        "settings": shared["settings_queue"],
        "pfb_cfg": shared["pfb_config_queue"],
        "corr_cfg": shared["corr_config_queue"],
    }

    read_proc = mp.Process(
        target=data_read,
        args=(SDR_URI, shared["raw_queue"], shared["settings_queue"],
              shared["stop_event"], monitor_queues),
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
        args=(shared["pfb_queue"], shared["corr_plot_queue"],
              shared["stop_event"], shared["corr_config_queue"]),
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