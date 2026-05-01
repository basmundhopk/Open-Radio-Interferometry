# Architecture

`open_radio_interferometry.apps.main` spawns four cooperating processes
communicating through bounded `multiprocessing.Queue`s:

```
FMCOMMS5 ──IIO──► data_read ──raw_queue──► pfb_process ──pfb_queue──► correlate_process
                      │                         │                          │
                      ▼                         ▼                          ▼
                 settings_queue           plot_queue                 corr_plot_queue
                      ▲                         │                          │
                      └────────── UI process (PyQt5) ◄──────────────────────┘
```

- `data_read` (`sdr/fmcomms5_iio.py`) configures the SDR and pushes raw
  4-channel IQ frames into `raw_queue`.
- `pfb_process` (`dsp/pfb.py`) consumes raw frames, applies the polyphase
  FIR / FFT, optionally notches DC, and pushes channelized spectra.
- `correlate_process` (`dsp/correlator.py`) computes all 10 baseline
  products, integrates, projects baselines onto the UV plane for the
  current LST, and emits UV / correlation frames.
- The UI process (`ui/main_window.py`) drains the plot queues, renders
  dockable panels, and pushes user changes back to the workers via the
  `*_config_queue`s.

## Package layout

| Subpackage  | Responsibility                                        |
|-------------|--------------------------------------------------------|
| `settings`  | Default parameters + persistent `QSettings` schema     |
| `sdr`       | Hardware capture (FMCOMMS5 over libiio)                |
| `dsp`       | Polyphase channelizer + cross-correlator               |
| `imaging`   | Hogbom CLEAN core (gridding, dirty image, restore)     |
| `ui`        | PyQt5 main window + interactive CLEAN dialog           |
| `apps`      | Console-script entry points                            |

Only `sdr/` depends on real hardware. `dsp`, `imaging`, and the
standalone `apps/uv_app`, `apps/clean_app`, `apps/uv_simulator` work on
any machine with the listed Python dependencies.
