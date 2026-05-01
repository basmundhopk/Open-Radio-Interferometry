# Open-Radio-Interferometry — IP Branch (WIP)

This branch extends the host-only [Open-Radio-Interferometry](README.md)
software correlator with **FPGA-accelerated channelization** for the
**Xilinx ZC706 + Analog Devices FMCOMMS5** platform. The polyphase filter
bank that normally runs in Python is replaced by a packaged Vivado IP
core instantiated in the ADI FMCOMMS5 reference HDL design, freeing the
host CPU and enabling higher continuous sample rates.

As the cores are finished and placed within the FPGA fabric, work will be done to make the main UI compatible with this system.

## IP Cores

### `pfb_multichannel_decimator` (used in the design)

A 4-channel coherent polyphase filter bank decimator, packaged as a
Vivado IP under
[IP/pfb_multichannel_decimator](IP/pfb_multichannel_decimator).

- 4 AXI-Stream IQ inputs (16-bit complex), 4 AXI-Stream channelized outputs
- Configurable FFT length `P` and taps-per-branch `M`
- Prototype FIR coefficients generated offline

### `pfb_block_decimator`

Single-stream block-decimating variant under
[IP/pfb_block_decimator](IP/pfb_block_decimator). Useful for testing,
single-antenna spectroscopy, or as a building block for arrays larger
than four elements.

### `correlator` (in development — not yet packaged into `IP/`)

A streaming FX correlator core is in development and will land under
[IP/](IP/) once stable:

- 4 channelized AXI-Stream inputs (16-bit complex)
- Computes all 10 unique baseline products
  (autos `00 11 22 33`, crosses `01 02 03 12 13 23`)
- 64-bit complex accumulation with run-time configurable integration count
- AXI-Stream output of integrated visibilities

## Hardware Requirements

- **Xilinx ZC706** evaluation board (Zynq-7000 XC7Z045)
- **Analog Devices FMCOMMS5** (dual AD9361, 4 coherent RX channels)

## Tool Requirements

| Tool                 | Tested with    | Used for                                  |
|----------------------|----------------|-------------------------------------------|
| Vivado               | 2023.2         | Block design, synthesis, implementation   |
| ADI HDL build flow   | latest         | FMCOMMS5 reference project & libraries    |

The `hdl/` tree follows the standard ADI build flow. See
[the ADI HDL build guide](https://wiki.analog.com/resources/fpga/docs/build)
for prerequisites.