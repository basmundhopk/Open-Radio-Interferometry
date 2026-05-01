# References

Sources consulted during the design and implementation of
Open-Radio-Interferometry.

## Textbooks

- **Wilson, Rohlfs & Hüttemeister.** *Tools of Radio Astronomy.* Springer.
  (General radio-astronomy background — antennas, receivers, calibration.)
- **Thompson, Moran & Swenson.** *Interferometry and Synthesis in Radio
  Astronomy.* Springer (3rd ed., 2017). The standard reference for
  interferometer geometry, fringe stopping, UV synthesis, and
  calibration theory.
- **Wilkinson, P.N., et al. (eds.).** *Phased Arrays for Radio Astronomy,
  Remote Sensing, and Satellite Communications.* Cambridge University
  Press. Phased-array theory and beamforming for radio-astronomy
  applications.
- **Kraus, J.D.** *Antennas.* McGraw-Hill. Antenna fundamentals,
  patterns, gain, and aperture theory.
- **Balanis, C.A.** *Engineering Electromagnetics.* Wiley.
  Electromagnetic propagation, transmission lines, and antenna
  fundamentals supporting the front-end design.

## Algorithms

- **Högbom, J.A.** "Aperture Synthesis with a Non-Regular Distribution
  of Interferometer Baselines." *Astronomy & Astrophysics Supplement
  Series*, 15:417, 1974. The original CLEAN algorithm — implemented in
  [src/open_radio_interferometry/imaging/clean.py](../src/open_radio_interferometry/imaging/clean.py).
- **Meeus, J.** *Astronomical Algorithms* (2nd ed.). Willmann-Bell, 1998.
  Standard reference for sidereal-time, hour-angle, and equatorial /
  horizontal coordinate conversions used in baseline projection.

## Online lectures and tutorials

- **NRAO Synthesis Imaging Summer School lectures and proceedings.**
  <https://science.nrao.edu/science/meetings/synthesis-imaging>
  Lectures on aperture synthesis, calibration, gridding, weighting, and
  deconvolution.
- **AstroBaki** (UC Berkeley radio-astronomy wiki).
  <https://casper.astro.berkeley.edu/astrobaki/>
  Practical notes on radiometry, interferometry, and basic radio-astronomy
  observing.
- **CASPER collaboration documentation and memos.**
  <https://casper.berkeley.edu/>
  Polyphase filter bank design, FX-correlator architecture, and reference
  implementations used as a guide for the channelizer in
  [src/open_radio_interferometry/dsp/pfb.py](../src/open_radio_interferometry/dsp/pfb.py).

## Hardware datasheets and documentation

- **Analog Devices.** *AD9361 Reference Manual* (UG-570). Transceiver
  programming model, RF chain, and clocking.
- **Analog Devices.** *FMCOMMS5 hardware reference.*
  <https://wiki.analog.com/resources/eval/user-guides/ad-fmcomms5-ebz>
  Board schematics, clock distribution, and ADI Linux / IIO image notes.
- **Analog Devices.** *libiio and pyadi-iio documentation.*
  <https://analogdevicesinc.github.io/libiio/> and
  <https://analogdevicesinc.github.io/pyadi-iio/>
  IIO API used by [src/open_radio_interferometry/sdr/fmcomms5_iio.py](../src/open_radio_interferometry/sdr/fmcomms5_iio.py)
  to configure the SDR and stream IQ samples.
- **Nooelec.** *SAWbird+ H1 datasheet.*
  <https://www.nooelec.com/store/sawbird-h1.html>
  1420 MHz SAW-filtered LNA used as the per-channel front end.

## Software citations

- **Astropy Collaboration.** "Astropy: A community Python package for
  astronomy." *A&A* 558, A33 (2013).
- **Astropy Collaboration.** "The Astropy Project: Building an Open-science
  Project and Status of the v2.0 Core Package." *AJ* 156, 123 (2018).
- **Astropy Collaboration.** "The Astropy Project: Sustaining and Growing
  a Community-oriented Open-source Project and the Latest Major Release
  (v5.0) of the Core Package." *ApJ* 935, 167 (2022).
  Used for FITS I/O of UV visibilities and dirty images.
