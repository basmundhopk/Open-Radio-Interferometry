# Open-Radio-Interferometry — IP Branch

This branch extends the host-only Open-Radio-Interferometry software
correlator with **FPGA-accelerated channelization** for the
**Xilinx ZC706 + Analog Devices FMCOMMS5** platform. The polyphase filter
bank that normally runs in Python is replaced by a pre-packaged Vivado IP
core (shipped under [IP/](IP/)) that is instantiated in the ADI FMCOMMS5
reference HDL design, freeing the host CPU and enabling higher continuous
sample rates.

The correlator, UV synthesis, dirty imaging, and CLEAN deconvolution still
run on the host (see the main-branch README for details on those stages
and the run-time UI). This document covers only the additional FPGA
hardware that lives on this branch.

## Branch Layout

```
hdl/                         # ADI HDL fork — Vivado project sources
  library/                   # ADI + custom IP cores
  projects/fmcomms5/zc706/   # Top-level Vivado project for ZC706
  Makefile, docs/, scripts/

IP/                          # Packaged Vivado IP (component.xml + RTL)
  pfb_block_decimator/       # Single-stream block-decimating PFB
  pfb_multichannel_decimator/# 4-channel coherent PFB (used in the design)
  pfb_multichannel_decimator.zip

python/                      # Same host application as the main branch
                             # — but the PFB worker can be bypassed when
                             #   the FPGA already produces channelized data.
```

## Hardware Targets

- **Xilinx ZC706** evaluation board (Zynq-7000 XC7Z045)
- **Analog Devices FMCOMMS5** (dual AD9361, 4 coherent RX channels)
- Vivado-supported host PC for synthesis & implementation

## Tool Requirements

| Tool                 | Tested with    | Used for                                  |
|----------------------|----------------|-------------------------------------------|
| Vivado               | 2022.2+        | Block design, synthesis, implementation   |
| ADI HDL build flow   | latest         | FMCOMMS5 reference project & libraries    |

The `hdl/` tree follows the standard ADI build flow. See
[the ADI HDL build guide](https://wiki.analog.com/resources/fpga/docs/build)
for prerequisites.

No HLS toolchain is required — the IP cores in [IP/](IP/) are already
packaged and ready to add to a Vivado IP catalog.

## IP Cores

Both cores live under [IP/](IP/) as standard Vivado IP packages
(`component.xml` + RTL + drivers + XGUI). Add the `IP/` folder to your
Vivado project's IP repository to pick them up.

### `pfb_multichannel_decimator` (used in the design)

A 4-channel coherent polyphase filter bank decimator packaged at
[IP/pfb_multichannel_decimator](IP/pfb_multichannel_decimator). A
pre-built archive is also provided at
[IP/pfb_multichannel_decimator.zip](IP/pfb_multichannel_decimator.zip)
for quick import into other projects.

- 4 AXI-Stream IQ inputs (16-bit complex), 4 AXI-Stream channelized outputs
- FFT length `P` and taps-per-branch `M` matching the host-side defaults
  in [python/settings.py](python/settings.py) (`P = 4096`, `M = 4`)
- Prototype FIR coefficients generated offline by the same routine the
  Python pipeline uses (`generate_win_coeffs_np` in
  [python/pfb.py](python/pfb.py)) — Blackman-Harris by default
- Fully pipelined streaming architecture; uses the Xilinx FFT IP core
- AXI4-Lite control register for run/halt and (optional) coefficient reload

### `pfb_block_decimator`

Single-stream block-decimating variant under
[IP/pfb_block_decimator](IP/pfb_block_decimator). Useful for testing,
single-antenna spectroscopy, or as a building block for arrays larger
than four elements.

## Build Flow

### 1. Register the IP repository

In Vivado, add the [IP/](IP/) directory to the project's IP repository
(Project Settings → IP → Repository) so that
`pfb_multichannel_decimator` and `pfb_block_decimator` appear in the IP
catalog.

### 2. Build the HDL project

```bash
cd hdl/projects/fmcomms5/zc706
make
```

This invokes the ADI flow: it pulls in the FMCOMMS5 reference design,
adds the `pfb_multichannel_decimator` IP into the block design, runs
synthesis & implementation, and produces a bitstream + boot files.

Build logs land in [logs/](logs/) and `vivado.jou`.

### 3. Boot the ZC706 and run the host app

Flash the resulting boot files to the ZC706 SD card (standard ADI
procedure), bring the board up on the network, then run the same Python
application as the main branch:

```bash
cd python
python3 main.py
```

When the FPGA PFB is active the host's PFB worker can be bypassed by
disabling it in the UI ("PFB enable" checkbox / `PFB_ENABLE = False` in
[python/settings.py](python/settings.py)); the host then ingests the
already-channelized data directly into the correlator.

## License

The Python sources and packaged IP are licensed under the
**Apache License 2.0** (see [LICENSE](LICENSE)).

The `hdl/` tree is a fork of Analog Devices' HDL repository and contains
components under several licenses (ADI BSD, JESD204, BSD-1-Clause, GPL-2,
LGPL). See [hdl/LICENSE](hdl/LICENSE) and the per-license files in
[hdl/](hdl/) for the specifics.
