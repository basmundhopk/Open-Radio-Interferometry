"""
File contatining functions for initialziing shared queues, applying FMComms5 configurations, and reading out data from the FPGA.

  - create_shared_state():  shared multiprocessing queues / events used by all workers
  - _apply_sdr_config():    push a runtime-config dict to the SDR hardware
  - data_read():            worker that streams raw IQ frames
"""

import multiprocessing as mp
import numpy as np
import queue          # only for queue.Full / queue.Empty
import time

from open_radio_interferometry.settings import QUEUE_SIZE, FRAME_SIZE

# Shared state needs ample queue sizes to avoid dropped frames
# If queues overflow, reduce sampling rate
def create_shared_state():
    return {
        "raw_queue":         mp.Queue(maxsize=QUEUE_SIZE),
        "pfb_queue":         mp.Queue(maxsize=QUEUE_SIZE),
        "plot_queue":        mp.Queue(maxsize=64),
        "corr_plot_queue":   mp.Queue(maxsize=64),
        "settings_queue":    mp.Queue(maxsize=16),
        "pfb_config_queue":  mp.Queue(maxsize=16),
        "corr_config_queue": mp.Queue(maxsize=16),
        "stop_event":        mp.Event(),
    }

# Settings are not currently applyable to individual channels
def _apply_sdr_config(sdr, cfg, _last={}):
    mode = cfg.get("gain_control_mode")
    if mode is not None and mode != _last.get("gain_control_mode"):
        sdr.gain_control_mode_chan0 = mode
        sdr.gain_control_mode_chan1 = mode
        sdr.gain_control_mode_chip_b_chan0 = mode
        sdr.gain_control_mode_chip_b_chan1 = mode
        _last["gain_control_mode"] = mode

    g = cfg.get("rx_gain")
    if g is not None and g != _last.get("rx_gain"):
        sdr.rx_hardwaregain_chan0 = g
        sdr.rx_hardwaregain_chan1 = g
        sdr.rx_hardwaregain_chip_b_chan0 = g
        sdr.rx_hardwaregain_chip_b_chan1 = g
        _last["rx_gain"] = g

    lo = cfg.get("rx_lo")
    if lo is not None and lo != _last.get("rx_lo"):
        sdr.rx_lo = lo
        sdr.rx_lo_chip_b = lo
        _last["rx_lo"] = lo

    bw = cfg.get("rx_rf_bandwidth")
    if bw is not None and bw != _last.get("rx_rf_bandwidth"):
        sdr.rx_rf_bandwidth = bw
        sdr.rx_rf_bandwidth_chip_b = bw
        _last["rx_rf_bandwidth"] = bw

    sr = cfg.get("rx_sample_rate")
    if sr is not None and sr != _last.get("rx_sample_rate"):
        sdr.sample_rate = sr
        _last["rx_sample_rate"] = sr

    lb = cfg.get("loopback")
    if lb is not None and lb != _last.get("loopback"):
        sdr.loopback = lb
        sdr.loopback_chip_b = lb
        _last["loopback"] = lb

    buf = cfg.get("rx_buffer_size")
    if buf is not None and buf != _last.get("rx_buffer_size"):
        sdr.rx_buffer_size = buf
        _last["rx_buffer_size"] = buf


def data_read(uri, raw_queue, settings_queue, stop_event, monitor_queues=None):
    import adi
    from settings import configuration, print_sdr_config

    try:
        sdr = adi.fmcomms5.FMComms5(uri=uri)
        configuration(sdr)
    except Exception as e:
        print(f"data_read: failed to connect to {uri}: {e}")
        return

    print(f"data_read: connected to {uri}  (channels={sdr.rx_enabled_channels})")

    _frame_size = FRAME_SIZE   # mutable local — updated via settings_queue

    # ── Drain any pre-queued persistent settings from main.py BEFORE the
    # SDR-config printout so the printed values reflect the user's actual
    # last-session settings, not the factory defaults from settings.py.
    # We give the queue a short grace window in case main pushes slightly
    # after data_read connects.
    grace_deadline = time.time() + 1.5
    drained_any = False
    while time.time() < grace_deadline:
        try:
            cfg = settings_queue.get(timeout=0.1)
        except (queue.Empty, mp.queues.Empty):
            if drained_any:
                break
            continue
        drained_any = True
        if "frame_size" in cfg:
            _frame_size = cfg.pop("frame_size")
        try:
            _apply_sdr_config(sdr, cfg)
        except Exception as e:
            print(f"data_read: startup config error: {e}")

    if drained_any:
        print(f"data_read: applied persistent settings  (frame_size={_frame_size})")

    # Print the ACTUAL applied configuration (persistent values, not defaults)
    print_sdr_config(sdr)

    dropped = 0
    total = 0
    last_report = time.time()
    t_call = time.perf_counter()

    while not stop_event.is_set():
        try:
            while True:
                cfg = settings_queue.get_nowait()
                if "frame_size" in cfg:
                    _frame_size = cfg.pop("frame_size")
                    print(f"data_read: frame_size → {_frame_size}")
                try:
                    _apply_sdr_config(sdr, cfg)
                    if cfg:
                        print(f"data_read: applied config {cfg}")
                except Exception as e:
                    print(f"data_read: config error: {e}")
        except Exception:
            pass

        try:
            t0 = time.perf_counter()
            data = sdr.rx()
            call_ms = (time.perf_counter() - t0) * 1000
            interval_ms = (t0 - t_call) * 1000
            t_call = t0

            if isinstance(data, (list, tuple)):
                num_samples = len(data[0])
                num_frames = num_samples // _frame_size
                for i in range(num_frames):
                    total += 1
                    frame_data = [ch[i * _frame_size:(i + 1) * _frame_size] for ch in data]
                    try:
                        raw_queue.put_nowait(frame_data)
                    except (queue.Full, mp.queues.Full):
                        dropped += 1
            else:
                num_samples = len(data)
                num_frames = num_samples // _frame_size
                for i in range(num_frames):
                    total += 1
                    frame_data = data[i * _frame_size:(i + 1) * _frame_size]
                    try:
                        raw_queue.put_nowait(frame_data)
                    except (queue.Full, mp.queues.Full):
                        dropped += 1
        except Exception as e:
            print(f"Capture Error: {e}")
            break

        now = time.time()
        elapsed = now - last_report
        try:
            qd = raw_queue.qsize()
        except NotImplementedError:
            qd = -1   # macOS does not support qsize()
        pct = 100 * dropped / total if total else 0
        sps = (total - dropped) * _frame_size / elapsed if elapsed else 0
        q_str = f"raw={qd}"
        if monitor_queues:
            for qname, qobj in monitor_queues.items():
                try:
                    q_str += f"  {qname}={qobj.qsize()}"
                except Exception:
                    pass
        print(
            f"[stats] queues: {q_str}  |  frames={total}  "
            f"dropped={dropped} ({pct:.1f}%)  rate={sps / 1e3:.1f} kSps  "
            f"rx()={call_ms:.1f}ms  interval={interval_ms:.1f}ms"
        )
        dropped = 0
        total = 0
        last_report = now

    print("Read stopped")
