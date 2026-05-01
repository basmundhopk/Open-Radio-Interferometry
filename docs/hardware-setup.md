# Hardware setup

## Bill of materials

- **Analog Devices EVAL-AD-FMCOMMS5-EBZ** — dual AD9361, 4 coherent RX
  channels, 70 MHz – 6 GHz tuning range.
- A host carrier supported by ADI's stock FMCOMMS5 image, e.g. **ZC706**
  or **ZCU102**, running the standard ADI Linux + IIO daemon.
- Network connection between the carrier and the host PC running this
  software.
- 4 antennas with known local East-North-Up positions.

## SDR configuration

The host connects to the IIO daemon over the network. The default URI is
`ip:analog.local`. Override it by editing `SDR_URI` at the top of
[`apps/main.py`](../src/open_radio_interferometry/apps/main.py) or by
exporting it through your shell wrapper.

## Antenna geometry

Edit `ANTENNA_POSITIONS_ENU` in
[`settings.py`](../src/open_radio_interferometry/settings.py) to match
your array. The default is an edge-on 25 m square. Coordinates are local
East / North / Up in metres relative to the array phase centre.

Also update the observatory latitude / longitude and the source RA/Dec
constants in the same file for correct LST / hour-angle computation and
fringe stopping.
