# FX-Correlator

An FPGA-based FX correlator for radio astronomy, targeting the **Xilinx ZC706** development board with the **Analog Devices FMCOMMS5** dual-AD9361 RF front-end. The system implements a polyphase filter bank (PFB) channelizer and a baseline correlator in hardware, with Python-based control, data acquisition, and visualization.

## Overview

The FX correlator architecture splits the processing into two stages:

- **F (Frequency)** — A 1024-point polyphase filter bank channelizes the incoming time-domain samples from 4 receive channels into narrow frequency bins.
- **X (Cross-correlation)** — A correlator computes all 10 baseline products (4 auto + 6 cross) across the channelized data, with configurable integration time.

The RF front-end is the FMCOMMS5 evaluation board, which provides 4 coherent receive channels (2× AD9361) tunable from 70 MHz to 6 GHz. The default configuration targets the **1420.4 MHz hydrogen line**.

## Repository Structure

```
├── hdl/            # Vivado HDL project (based on ADI's FMCOMMS5 reference design)
│   ├── library/    # IP cores (ADI + custom)
│   └── projects/
│       └── fmcomms5/zc706/   # Top-level Vivado project for ZC706
│
├── hls/            # Vitis HLS source code
│   ├── hls_correlator/       # FX correlator core (4-input, 10-baseline)
│   ├── hls_pfb/              # Polyphase filter bank channelizer
│   └── hls_pfb_sample/       # PFB sample/reference design
│
├── IP/             # Exported/packaged IP blocks
│   ├── pfb_block_decimator/
│   └── pfb_multichannel_decimator/
│
├── python/         # Host-side control and data acquisition
│   ├── main.py               # Main application entry point
│   ├── fmcomms5_iio.py       # IIO data capture, processing, and plotting
│   ├── settings.py           # SDR configuration (freq, gain, sample rate, etc.)
│   ├── pfb.py                # PFB utilities
│   └── test.py               # Threading test
│
└── logs/           # Build and runtime logs
```

## Hardware Requirements

- **Xilinx ZC706** evaluation board (Zynq-7000 SoC)
- **Analog Devices FMCOMMS5** (EVAL-AD-FMCOMMS5-EBZ) — dual AD9361 FMC card

## Software Requirements

- **Vivado** (for HDL synthesis and implementation)
- **Vitis HLS** (for building the PFB and correlator IP cores)
- **Python 3** with the following packages:
  - `pyadi-iio` — ADI hardware abstraction via IIO
  - `numpy`
  - `matplotlib`

## HLS IP Cores

### Polyphase Filter Bank (`hls_pfb`)

- 4-channel, 1024-point FFT with 4-tap FIR filter per bin
- Pipelined streaming architecture
- 16-bit fixed-point I/Q input, configurable output width
- Uses Xilinx FFT IP core via HLS

### Correlator (`hls_correlator`)

- Accepts 4 channelized input streams (16-bit complex)
- Computes all 10 unique baseline products (auto: 00, 11, 22, 33; cross: 01, 02, 03, 12, 13, 23)
- 64-bit complex accumulation with configurable integration time
- AXI-Stream interfaces for input and output

## Python Application

The Python application connects to the FMCOMMS5 via `libiio` / `pyadi-iio` and provides:

- Real-time multi-channel I/Q data capture
- Threaded acquisition pipeline with frame buffering
- Live time-domain plotting of all 4 channels (I and Q)

### Default Configuration

| Parameter         | Value          |
|-------------------|----------------|
| Center Frequency  | 1420.4 MHz     |
| Sample Rate       | 1 MSPS         |
| RF Bandwidth      | 10 MHz         |
| Gain Control      | Fast Attack    |
| Buffer Size       | 4096 samples   |
| Channels          | 0, 1, 2, 3    |

## Building the HDL Project

The HDL project is based on [Analog Devices' HDL reference design](https://github.com/analogdevicesinc/hdl).

Refer to the [ADI HDL build guide](https://wiki.analog.com/resources/fpga/docs/build) for prerequisites and detailed instructions.

## License

This project is licensed under the **Apache License 2.0**. See [LICENSE](LICENSE) for details.

The HDL submodule contains components under various licenses (BSD, GPL2, LGPL) — see [hdl/LICENSE](hdl/LICENSE) and related license files for specifics.
