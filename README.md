# Open-Radio-Interferometry — IP Branch

This branch extends the host-only [Open-Radio-Interferometry](README.md)
software correlator with **FPGA-accelerated channelization** for the
**Xilinx ZC706 + Analog Devices FMCOMMS5** platform. The polyphase filter
bank that normally runs in Python is replaced by a Vitis-HLS-generated IP
block instantiated in the ADI FMCOMMS5 reference HDL design, freeing the
host CPU and enabling higher continuous sample rates.

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

hls/                         # Vitis HLS source for the custom blocks
  hls_pfb/                   # Streaming multichannel PFB channelizer
    pfb.h, pfb_top.cpp, pfb_compute.cpp, pfb_fft.cpp,
    pfb_io.cpp, pfb_helper.cpp, pfb_tb.cpp
  hls_pfb_sample/            # Reduced reference design / sandbox
  hls_correlator/            # Streaming FX correlator core
    correlator.h, correlator_top.cpp, correlator_io.cpp,
    correlator_tb.cpp, correlator_tb2.cpp

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
| Vitis HLS            | 2022.2+        | Building the PFB and correlator IP cores  |
| ADI HDL build flow   | latest         | FMCOMMS5 reference project & libraries    |

The `hdl/` tree follows the standard ADI build flow. See
[the ADI HDL build guide](https://wiki.analog.com/resources/fpga/docs/build)
for prerequisites.

## IP Cores

### `pfb_multichannel_decimator` (used in the design)

A 4-channel coherent polyphase filter bank decimator generated from
[hls/hls_pfb](hls/hls_pfb). Packaged as a Vivado IP under
[IP/pfb_multichannel_decimator](IP/pfb_multichannel_decimator).

- 4 AXI-Stream IQ inputs (16-bit complex), 4 AXI-Stream channelized outputs
- Configurable FFT length `P` and taps-per-branch `M` (default `P = 4096`,
  `M = 4`, matching the host-side defaults in
  [python/settings.py](python/settings.py))
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

### `hls_correlator` (HLS source only — not yet packaged into `IP/`)

Streaming FX correlator skeleton in [hls/hls_correlator](hls/hls_correlator):

- 4 channelized AXI-Stream inputs (16-bit complex)
- Computes all 10 unique baseline products
  (autos `00 11 22 33`, crosses `01 02 03 12 13 23`)
- 64-bit complex accumulation with run-time configurable integration count
- AXI-Stream output of integrated visibilities

Once packaged, this block can replace the host-side
`correlate_process` (in [python/correlator.py](python/correlator.py)) for
even greater offload.

## Build Flow

### 1. Build the HLS IP

```bash
cd hls/hls_pfb
vitis_hls -f hls_config.cfg     # generates Vivado IP
```

Repeat for `hls/hls_correlator` and `hls/hls_pfb_sample` as needed. The
generated IPs are exported into the matching directory under `IP/`.

### 2. Build the HDL project

```bash
cd hdl/projects/fmcomms5/zc706
make
```

This invokes the ADI flow: it pulls in the FMCOMMS5 reference design,
adds the custom `pfb_multichannel_decimator` IP into the block design,
runs synthesis & implementation, and produces a bitstream + boot files.

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

The Python and HLS sources are licensed under the **Apache License 2.0**
(see [LICENSE](LICENSE)).

The `hdl/` tree is a fork of Analog Devices' HDL repository and contains
components under several licenses (ADI BSD, JESD204, BSD-1-Clause, GPL-2,
LGPL). See [hdl/LICENSE](hdl/LICENSE) and the per-license files in
[hdl/](hdl/) for the specifics.
