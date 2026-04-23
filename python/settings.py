"""
Settings for Open Radio Interferometry — persistent constants and SDR setup.

All values live in a single Settings class that is installed as the module
itself, so existing code using ``import settings; settings.X`` or
``from settings import X`` continues to work unchanged.

New helpers:
  - settings.load()   — reload from QSettings (runs automatically on import)
  - settings.save()   — persist current values to QSettings
  - settings.reset()  — restore factory defaults (does not save)
  - settings.configuration(sdr)    — apply current values to an FMComms5 instance
  - settings.print_sdr_config(sdr) — print the live SDR configuration
"""

import sys
import copy
import types


class _Settings(types.ModuleType):
    """
    Live settings namespace backed by QSettings persistence.

    Every setting is a plain instance attribute — read or rewrite it directly::

        import settings
        settings.rx_lo = 1_420_000_000
        settings.save()          # persist to disk
        settings.load()          # reload from disk
        settings.reset()         # back to factory defaults
    """

    _DEFAULTS = dict(
        # IIO
        FRAME_SIZE                   = 4096,
        BUFFER_SIZE                  = 4096 * 100,
        QUEUE_SIZE                   = 10000,
        
        # PFB
        P                            = 4096,            # FFT size (= FRAME_SIZE)
        M                            = 4,               # taps-per-branch
        PFB_WINDOW                   = "blackman-harris",
        PFB_FFTSHIFT                 = True,            # centre DC in plot
        PFB_ENABLE                   = True,            # False → raw FFT
        DC_NOTCH_KHZ                 = 20,              # ±N kHz zeroed around DC (0 = off)
        LO_OFFSET_KHZ                = 500,             # shift LO to move DC spike
        
        # FMCOMMS5
        filter_fir                   = '',              # path to FIR filter file
        gain_control_mode            = 'fast_attack',   # slow_attack | fast_attack | manual
        loopback                     = 0,               # 0=off  1=digital  2=RF
        rx_gain                      = 70,              # dB (manual mode only)
        rx_lo                        = 1420400000,      # carrier frequency (Hz)
        rx_rf_bandwidth              = 2000000,         # filter bandwidth (Hz)
        rx_sample_rate               = 2500000,         # sample rate (Hz)
        rx_buffer                    = 4096 * 100,      # RX buffer size (samples)
        rx_output_type               = 'raw',           # 'raw' or 'SI'
        rx_channels                  = [0, 1, 2, 3],
        rx_annotated                 = False,
        
        # UI
        PLOT_INTERVAL                = 0.1,             # seconds between plot updates
        
        # Observing
        INTEGRATION_COUNT            = 10000,           # spectra averaged before emit
        IFFT_GRID_SIZE               = 128,             # dirty-image IFFT size (NxN)
        OBSERVATION_LATITUDE_DEG     = 39.527,          # observatory latitude
        OBSERVATION_LONGITUDE_DEG    = -119.822,        # observatory longitude
        OBSERVATION_DECLINATION_DEG  = 40.734,          # source declination
        SOURCE_RA_DEG                = 299.75,          # source RA (0 = drift mode)
        
        # Array geometry — local East-North-Up coordinates (metres)
        ANTENNA_POSITIONS_ENU        = [
            (-25.0,  0.0, 0.0),         # Antenna 0  (RX channel 0)
            (  0.0, 25.0, 0.0),         # Antenna 1  (RX channel 1)
            ( 25.0,  0.0, 0.0),         # Antenna 2  (RX channel 2)
            (  0.0,-25.0, 0.0),         # Antenna 3  (RX channel 3)
        ],
        CHANNEL_TO_ANTENNA           = {0: 0, 1: 1, 2: 2, 3: 3},
    )

    def __init__(self, name, doc=""):
        super().__init__(name, doc)
        self.__dict__.update(copy.deepcopy(self._DEFAULTS))
        self.load()

    def load(self):
        """Override defaults with the last-saved QSettings values (if available)."""
        try:
            from PyQt5.QtCore import QSettings
            qs = QSettings("FX_Correlator", "FX_Correlator")

            def _f(k, d):   return float(qs.value(k, d, type=float))
            def _i(k, d):   return int(qs.value(k, d, type=int))
            def _s(k, d):   return str(qs.value(k, d, type=str))
            def _b(k, d):
                raw = qs.value(k, d)
                return raw.lower() in ("true", "1", "yes", "on") if isinstance(raw, str) else bool(raw)

            # device
            self.LO_OFFSET_KHZ           = _f("device/lo_offset_khz",    self.LO_OFFSET_KHZ)
            self.rx_lo                   = int(_f("device/rx_lo_mhz",     self.rx_lo / 1e6) * 1e6)
            self.rx_rf_bandwidth         = int(_f("device/rf_bw_mhz",     self.rx_rf_bandwidth / 1e6) * 1e6)
            self.rx_sample_rate          = int(_f("device/sample_rate_mhz", self.rx_sample_rate / 1e6) * 1e6)
            self.gain_control_mode       = _s("device/gain_mode",         self.gain_control_mode)
            self.rx_gain                 = _i("device/gain_db",           self.rx_gain)
            # pfb
            self.PFB_ENABLE              = _b("pfb/enabled",              self.PFB_ENABLE)
            self.P                       = _i("pfb/fft_size",             self.P)
            self.FRAME_SIZE              = self.P           # kept in sync with P
            self.BUFFER_SIZE             = self.P * 100
            self.rx_buffer               = self.BUFFER_SIZE
            self.M                       = _i("pfb/taps_M",               self.M)
            self.PFB_WINDOW              = _s("pfb/window",               self.PFB_WINDOW)
            self.PFB_FFTSHIFT            = _b("pfb/fftshift",             self.PFB_FFTSHIFT)
            self.DC_NOTCH_KHZ            = _f("pfb/dc_notch_khz",         self.DC_NOTCH_KHZ)
            # display
            self.PLOT_INTERVAL           = _f("display/interval_s",       self.PLOT_INTERVAL)
            # correlator / observing
            self.INTEGRATION_COUNT       = _i("corr/integration_count",   self.INTEGRATION_COUNT)
            self.IFFT_GRID_SIZE          = _i("corr/ifft_grid_size",      self.IFFT_GRID_SIZE)
            self.SOURCE_RA_DEG           = _f("corr/source_ra_deg",       self.SOURCE_RA_DEG)
            self.OBSERVATION_DECLINATION_DEG = _f("corr/source_dec_deg",  self.OBSERVATION_DECLINATION_DEG)
            # antenna positions
            ant = []
            for ai in range(4):
                e_def = self.ANTENNA_POSITIONS_ENU[ai][0] if ai < len(self.ANTENNA_POSITIONS_ENU) else 0.0
                n_def = self.ANTENNA_POSITIONS_ENU[ai][1] if ai < len(self.ANTENNA_POSITIONS_ENU) else 0.0
                ant.append((_f(f"ant/{ai}_east", e_def), _f(f"ant/{ai}_north", n_def), 0.0))
            self.ANTENNA_POSITIONS_ENU   = ant
        except Exception:
            pass   # QSettings unavailable (headless / pre-Qt); keep defaults

    def save(self):
        """Persist the current values to QSettings."""
        try:
            from PyQt5.QtCore import QSettings
            qs = QSettings("FX_Correlator", "FX_Correlator")
            qs.setValue("device/lo_offset_khz",    float(self.LO_OFFSET_KHZ))
            qs.setValue("device/rx_lo_mhz",        float(self.rx_lo) / 1e6)
            qs.setValue("device/rf_bw_mhz",        float(self.rx_rf_bandwidth) / 1e6)
            qs.setValue("device/sample_rate_mhz",  float(self.rx_sample_rate) / 1e6)
            qs.setValue("device/gain_mode",         str(self.gain_control_mode))
            qs.setValue("device/gain_db",           int(self.rx_gain))
            qs.setValue("pfb/enabled",              bool(self.PFB_ENABLE))
            qs.setValue("pfb/fft_size",             int(self.P))
            qs.setValue("pfb/taps_M",               int(self.M))
            qs.setValue("pfb/window",               str(self.PFB_WINDOW))
            qs.setValue("pfb/fftshift",             bool(self.PFB_FFTSHIFT))
            qs.setValue("pfb/dc_notch_khz",         float(self.DC_NOTCH_KHZ))
            qs.setValue("display/interval_s",       float(self.PLOT_INTERVAL))
            qs.setValue("corr/integration_count",   int(self.INTEGRATION_COUNT))
            qs.setValue("corr/ifft_grid_size",      int(self.IFFT_GRID_SIZE))
            qs.setValue("corr/source_ra_deg",       float(self.SOURCE_RA_DEG))
            qs.setValue("corr/source_dec_deg",      float(self.OBSERVATION_DECLINATION_DEG))
            for ai, pos in enumerate(self.ANTENNA_POSITIONS_ENU):
                qs.setValue(f"ant/{ai}_east",  float(pos[0]))
                qs.setValue(f"ant/{ai}_north", float(pos[1]))
            qs.sync()
        except Exception:
            pass

    def reset(self):
        """Restore factory defaults (does not write to QSettings)."""
        self.__dict__.update(copy.deepcopy(self._DEFAULTS))

    def configuration(self, sdr):
        """Apply current settings to an FMComms5 SDR instance."""
        sdr.sample_rate              = self.rx_sample_rate
        sdr.rx_buffer_size           = self.rx_buffer
        sdr.rx_output_type           = self.rx_output_type
        sdr.rx_annotated             = self.rx_annotated
        sdr.rx_enabled_channels      = self.rx_channels

        # chip A
        sdr.gain_control_mode_chan0  = self.gain_control_mode
        sdr.gain_control_mode_chan1  = self.gain_control_mode
        sdr.loopback                 = self.loopback
        sdr.rx_hardwaregain_chan0    = self.rx_gain
        sdr.rx_hardwaregain_chan1    = self.rx_gain
        sdr.rx_lo                    = self.rx_lo
        sdr.rx_rf_bandwidth          = self.rx_rf_bandwidth

        # chip B
        sdr.gain_control_mode_chip_b_chan0 = self.gain_control_mode
        sdr.gain_control_mode_chip_b_chan1 = self.gain_control_mode
        sdr.loopback_chip_b                = self.loopback
        sdr.rx_hardwaregain_chip_b_chan0   = self.rx_gain
        sdr.rx_hardwaregain_chip_b_chan1   = self.rx_gain
        sdr.rx_rf_bandwidth_chip_b         = self.rx_rf_bandwidth
        sdr.rx_lo_chip_b                   = self.rx_lo

    def print_sdr_config(self, sdr):
        """Print the currently-applied FMComms5 configuration.
        Called by data_read AFTER any pre-queued persistent UI settings have
        been applied, so the values shown reflect what is actually in use."""
        print("\n=== FMComms5 Configuration ===")
        print("\n--- Chip A ---")
        print(f"  gain_control_mode_chan0: {sdr.gain_control_mode_chan0}")
        print(f"  gain_control_mode_chan1: {sdr.gain_control_mode_chan1}")
        print(f"  loopback: {sdr.loopback}")
        print(f"  rx_hardwaregain_chan0: {sdr.rx_hardwaregain_chan0} dB")
        print(f"  rx_hardwaregain_chan1: {sdr.rx_hardwaregain_chan1} dB")
        print(f"  rx_lo: {sdr.rx_lo} Hz ({sdr.rx_lo/1e6:.3f} MHz)")
        print(f"  rx_rf_bandwidth: {sdr.rx_rf_bandwidth} Hz ({sdr.rx_rf_bandwidth/1e6:.1f} MHz)")
        print("\n--- Chip B ---")
        print(f"  gain_control_mode_chip_b_chan0: {sdr.gain_control_mode_chip_b_chan0}")
        print(f"  gain_control_mode_chip_b_chan1: {sdr.gain_control_mode_chip_b_chan1}")
        print(f"  loopback_chip_b: {sdr.loopback_chip_b}")
        print(f"  rx_hardwaregain_chip_b_chan0: {sdr.rx_hardwaregain_chip_b_chan0} dB")
        print(f"  rx_hardwaregain_chip_b_chan1: {sdr.rx_hardwaregain_chip_b_chan1} dB")
        print(f"  rx_lo_chip_b: {sdr.rx_lo_chip_b} Hz ({sdr.rx_lo_chip_b/1e6:.3f} MHz)")
        print(f"  rx_rf_bandwidth_chip_b: {sdr.rx_rf_bandwidth_chip_b} Hz ({sdr.rx_rf_bandwidth_chip_b/1e6:.1f} MHz)")
        print("\n--- General Settings ---")
        print(f"  sample_rate: {sdr.sample_rate} Hz ({sdr.sample_rate/1e6:.3f} MHz)")
        print(f"  rx_buffer_size: {sdr.rx_buffer_size} samples")
        print(f"  rx_output_type: {sdr.rx_output_type}")
        print(f"  rx_annotated: {sdr.rx_annotated}")
        print(f"  rx_enabled_channels: {sdr.rx_enabled_channels}")
        print("==============================\n")


# Replace this module with the Settings instance so that all attribute
# accesses (``import settings; settings.X = v``) and all
# ``from settings import X`` imports continue to work transparently.
sys.modules[__name__] = _Settings(__name__, __doc__)