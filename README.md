# Open-Radio-Interferometry

A software FX correlator and aperture-synthesis imager for amateur radio
astronomy, built around the **Analog Devices FMCOMMS5** (dual-AD9361, four
coherent RX channels) paired with a host PC. All signal processing — channel
acquisition, polyphase channelization, cross-correlation, UV synthesis, dirty
imaging, and CLEAN deconvolution — runs in Python on the host. The FPGA simply
streams raw IQ to the host over the standard ADI IIO interface.

The default configuration targets the **1420.405 MHz neutral-hydrogen line**
with a 4-element interferometer.

## Features

- Live capture of 4 coherent IQ streams from the FMCOMMS5 over `libiio`
- Multi-process pipeline (capture → PFB → correlator → UI) for low-latency
  real-time operation
- Polyphase filter bank channelizer with selectable prototype window
  (Blackman-Harris, Hamming, Hann, Kaiser) and configurable FFT size / taps
- Full baseline cross-correlator (4 autos + 6 crosses) with configurable
  integration time and DC notch
- UV-plane synthesis from local antenna ENU coordinates, source RA/Dec, and
  observatory lat/lon, with proper LST/hour-angle projection and fringe
  stopping
- Dirty-image gridding + 2-D IFFT, configurable image grid (64²–2048²)
- Interactive Hogbom CLEAN deconvolution dialog (step 1 / 10 / 100 / 1000
  iterations, restored beam fit)
- FITS export of UV visibilities and dirty images (astropy)
- Standalone tools:
  - `uv_app.py` — open and inspect a UV-plane FITS file
  - `clean_app.py` — run interactive CLEAN on any compatible FITS
  - `uv_simulator.py` — simulate UV coverage for a given array, source, and
    observation window
- Persistent settings (QSettings) so the last-used SDR / PFB / correlator
  parameters are restored on launch
- Dark-themed PyQt5 + pyqtgraph UI with dockable plot panels

## Repository Layout

```
python/
  main.py            # Entry point — launches capture / PFB / correlator / UI processes
  fmcomms5_iio.py    # FMCOMMS5 IIO capture worker and shared-state factory
  settings.py        # Persistent settings (SDR, PFB, correlator, antenna geometry)
  pfb.py             # Polyphase filter bank prototype + worker process
  correlator.py      # Cross-correlation, UV synthesis, fringe stopping, FITS export
  ui.py              # PyQt5 + pyqtgraph main window, control panels, live plots
  clean.py           # Hogbom CLEAN core (gridding, dirty image, PSF fit, restore)
  clean_dialog.py    # Interactive CLEAN dialog
  clean_app.py       # Standalone CLEAN viewer
  uv_app.py          # Standalone UV-plane viewer
  uv_simulator.py    # UV-coverage simulator
LICENSE
README.md
```

## Hardware

- **Analog Devices FMCOMMS5** (EVAL-AD-FMCOMMS5-EBZ) — dual AD9361, 4 coherent
  RX channels, tunable 70 MHz – 6 GHz
- Any host carrier supported by ADI's stock FMCOMMS5 image (e.g. ZC706,
  ZCU102) running the standard ADI Linux + IIO daemon. The application
  connects to the board over the network using its IIO URI
  (default `ip:analog.local`)
- 4 antennas with known local East-North-Up positions — defaults are an
  edge-on 25 m square; edit `ANTENNA_POSITIONS_ENU` in
  [python/settings.py](python/settings.py) to match your array

## Software Requirements

- Python 3.9+
- `pyadi-iio` (and `libiio` runtime)
- `numpy`
- `PyQt5`
- `pyqtgraph`
- `astropy` (for FITS I/O)

Install with:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install pyadi-iio numpy PyQt5 pyqtgraph astropy
```

## Running

With the FMCOMMS5 reachable on the network:

```bash
cd python
python3 main.py
```

The default IIO URI is `ip:analog.local`. To use a different host, edit
`SDR_URI` at the top of [python/main.py](python/main.py).

The UI opens with live time-domain, spectrum, baseline, UV-plane, and
dirty-image panels. Use the dockable settings panel to change LO frequency,
sample rate, RF bandwidth, gain, PFB parameters, and integration count, then
click **Apply** for each section to push the change to the running workers.

### Standalone tools

```bash
python3 uv_app.py            [path/to/file.fits]   # UV viewer
python3 clean_app.py         [path/to/file.fits]   # Interactive CLEAN
python3 uv_simulator.py                            # UV-coverage simulator
```

## Default Configuration

| Parameter             | Default                                  |
|-----------------------|------------------------------------------|
| Center frequency      | 1 420.400 MHz (HI line)                  |
| Sample rate           | 2.5 MSPS                                 |
| RF bandwidth          | 2 MHz                                    |
| Gain control          | Fast attack                              |
| Frame size / FFT (P)  | 4096                                     |
| PFB taps per branch (M) | 4                                      |
| Window                | Blackman-Harris                          |
| Integration count     | 10 000 spectra                           |
| Dirty-image grid      | 128 × 128                                |
| RX channels           | 0, 1, 2, 3                               |
| Observatory           | 39.527° N, −119.822° E                   |
| Source declination    | 40.734°                                  |

All values are persisted via `QSettings` between runs.

## Architecture

`main.py` spawns four cooperating processes communicating through bounded
`multiprocessing.Queue`s:

```
FMCOMMS5 ──IIO──► data_read ──raw_queue──► pfb_process ──pfb_queue──► correlate_process
                      │                         │                          │
                      ▼                         ▼                          ▼
                 settings_queue           plot_queue                 corr_plot_queue
                      ▲                         │                          │
                      └────────── UI process (PyQt5) ◄──────────────────────┘
```

- `data_read` (fmcomms5_iio.py) configures the SDR and pushes raw 4-channel
  IQ frames into `raw_queue`.
- `pfb_process` (pfb.py) consumes raw frames, applies the polyphase FIR /
  FFT, optionally notches DC, and pushes channelized spectra.
- `correlate_process` (correlator.py) computes all 10 baseline products,
  integrates, projects baselines onto the UV plane for the current LST,
  and emits UV / correlation frames for plotting and FITS export.
- The UI process (ui.py) drains the plot queues, renders dockable panels,
  and pushes user changes back to the workers via the `*_config_queue`s.

## License

Licensed under the **Apache License 2.0**. See [LICENSE](LICENSE) for details.
