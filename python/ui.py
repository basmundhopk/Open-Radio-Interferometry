"""
PyQt5 + Matplotlib GUI for the FX Correlator.

  - PlotCanvas:           matplotlib canvas widget embedded in Qt
  - SettingsPanel:        runtime control panel (SDR / PFB / correlator settings)
  - MainWindow:           top-level window with all plots and dock panels
  - _apply_dark_palette(): apply dark theme palette to a QApplication
  - run_ui():             launch the Qt event loop with the worker queues
"""

import sys
import math
import time
import numpy as np

import matplotlib
matplotlib.use("Qt5Agg")

from matplotlib.backends.backend_qt5agg import (
    FigureCanvasQTAgg,
    NavigationToolbar2QT,
)
from matplotlib.figure import Figure

from PyQt5.QtWidgets import (
    QApplication,
    QMainWindow,
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QGroupBox,
    QLabel,
    QComboBox,
    QCheckBox,
    QPushButton,
    QScrollArea,
    QDockWidget,
    QStatusBar,
    QFormLayout,
    QSpinBox,
    QDoubleSpinBox,
    QSizePolicy,
    QMessageBox,
    QFileDialog,
)
from PyQt5.QtCore import Qt, QTimer, pyqtSignal, QSettings
from PyQt5.QtGui import QPalette, QColor

import settings
from pfb import generate_win_coeffs_np


# ──────────────────────────────────────────────────────────────────────────
# Persistent-settings loader usable BEFORE any QApplication exists.
#
# main.py calls this before spawning worker processes so that each worker
# receives the user's last-session values via its config queue on startup
# (rather than the factory defaults from settings.py). This fixes two
# problems:
#
#   1. Values shown in the UI after restart don't take effect until the
#      user clicks Apply — the workers never heard about them.
#   2. The SDR configuration printout on startup shows factory defaults
#      instead of the user's actual values.
#
# Uses the exact same QSettings keys and dict shapes produced by
# SettingsPanel._on_apply_device / _on_apply_pfb / _on_apply_corr so the
# workers cannot tell the difference between these startup messages and
# an Apply button click.
# ──────────────────────────────────────────────────────────────────────────
def load_persistent_configs():
    """
    Read persistent settings via QSettings and return
    (device_cfg, pfb_cfg, corr_cfg, frame_size).

    Returned dicts are ready to be put directly on
    shared["settings_queue"], shared["pfb_config_queue"], and
    shared["corr_config_queue"] respectively.
    """
    qs = QSettings("FX_Correlator", "FX_Correlator")

    def _f(k, d):
        return float(qs.value(k, d, type=float))

    def _i(k, d):
        return int(qs.value(k, d, type=int))

    def _b(k, d):
        raw = qs.value(k, d)
        if isinstance(raw, str):
            return raw.lower() in ("true", "1", "yes", "on")
        return bool(raw)

    def _s(k, d):
        return str(qs.value(k, d, type=str))

    S = settings

    # ── device ──
    lo_offset_hz = int(_f("device/lo_offset_khz", S.LO_OFFSET_KHZ) * 1e3)
    target_lo_hz = int(_f("device/rx_lo_mhz", S.rx_lo / 1e6) * 1e6)
    device_cfg = {
        "rx_lo":              target_lo_hz + lo_offset_hz,
        "rx_rf_bandwidth":    int(_f("device/rf_bw_mhz",    S.rx_rf_bandwidth / 1e6) * 1e6),
        "rx_sample_rate":     int(_f("device/sample_rate_mhz", S.rx_sample_rate / 1e6) * 1e6),
        "gain_control_mode":  _s("device/gain_mode",       S.gain_control_mode),
        "rx_gain":            _i("device/gain_db",         S.rx_gain),
        "loopback":           int(S.loopback),  # not persisted per _build_persistent_registry
        "lo_offset_hz":       lo_offset_hz,
    }

    # ── pfb ──
    pfb_cfg = {
        "PFB_ENABLE":     _b("pfb/enabled",       S.PFB_ENABLE),
        "P":              _i("pfb/fft_size",      S.P),
        "M":              _i("pfb/taps_M",        S.M),
        "PFB_WINDOW":     _s("pfb/window",        S.PFB_WINDOW),
        "PFB_FFTSHIFT":   _b("pfb/fftshift",      S.PFB_FFTSHIFT),
        "DC_NOTCH_KHZ":   _f("pfb/dc_notch_khz",  S.DC_NOTCH_KHZ),
    }

    # ── frame size follows P (the PFB FFT length) ──
    frame_size = int(pfb_cfg["P"])

    # ── correlator / integration / UV / RFI ──
    ant_positions = []
    for ai in range(4):
        e_def = S.ANTENNA_POSITIONS_ENU[ai][0] if ai < len(S.ANTENNA_POSITIONS_ENU) else 0.0
        n_def = S.ANTENNA_POSITIONS_ENU[ai][1] if ai < len(S.ANTENNA_POSITIONS_ENU) else 0.0
        ant_positions.append((
            _f(f"ant/{ai}_east",  e_def),
            _f(f"ant/{ai}_north", n_def),
            0.0,
        ))
    corr_cfg = {
        "integration_count":    _i("corr/integration_count",   S.INTEGRATION_COUNT),
        "ifft_grid_size":       _i("corr/ifft_grid_size",      int(S.IFFT_GRID_SIZE)),
        "source_ra_deg":        _f("corr/source_ra_deg",       float(S.SOURCE_RA_DEG)),
        "source_dec_deg":       _f("corr/source_dec_deg",      float(S.OBSERVATION_DECLINATION_DEG)),
        "fringe_stop":          _b("corr/fringe_stop",         True),
        "autocorr_norm_cross":  _b("corr/autocorr_norm_cross", True),
        "autocorr_norm_autos":  _b("corr/autocorr_norm_autos", False),
        "rfi_flag":             _b("corr/rfi_flag",            True),
        "rfi_sigma":            _f("corr/rfi_sigma",           5.0),
        "antenna_positions":    ant_positions,
        "dc_notch_khz":         pfb_cfg["DC_NOTCH_KHZ"],
    }

    return device_cfg, pfb_cfg, corr_cfg, frame_size

_MPL_DARK = {
    "figure.facecolor": "#2b2b2b",
    "axes.facecolor": "#1e1e1e",
    "axes.edgecolor": "#555555",
    "axes.labelcolor": "#cccccc",
    "axes.titlesize": 9,
    "axes.labelsize": 8,
    "text.color": "#cccccc",
    "xtick.color": "#aaaaaa",
    "ytick.color": "#aaaaaa",
    "xtick.labelsize": 7,
    "ytick.labelsize": 7,
    "grid.color": "#444444",
    "grid.alpha": 0.5,
    "legend.fontsize": 7,
    "legend.facecolor": "#2b2b2b",
    "legend.edgecolor": "#555555",
    "figure.titlesize": 11,
    "lines.linewidth": 0.8,
}
matplotlib.rcParams.update(_MPL_DARK)

CORR_KEYS = ["00", "01", "02", "03", "11", "12", "13", "22", "23", "33"]


#  Matplotlib canvas widget
class PlotCanvas(FigureCanvasQTAgg):
    def __init__(self, parent=None, dpi=100):
        self.fig = Figure(dpi=dpi)
        super().__init__(self.fig)
        self.setParent(parent)
        self.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)


#  Settings panel (left sidebar)
class SettingsPanel(QWidget):
    """All user-tweakable knobs live here."""

    device_settings_changed = pyqtSignal(dict)
    pfb_settings_changed = pyqtSignal(dict)
    corr_settings_changed = pyqtSignal(dict)
    plot_selection_changed = pyqtSignal()
    display_settings_changed = pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._init_ui()

    # ── build ──────────────────────────────────────────────────
    def _init_ui(self):
        root = QVBoxLayout(self)
        root.setContentsMargins(6, 6, 6, 6)

        # ── SDR Device Settings ───────────────────────────────
        dev = QGroupBox("SDR Device Settings")
        df = QFormLayout()

        self.lo_input = QDoubleSpinBox()
        self.lo_input.setRange(70.0, 6000.0)
        self.lo_input.setDecimals(3)
        self.lo_input.setSuffix("  MHz")
        self.lo_input.setValue(settings.rx_lo / 1e6)
        self.lo_input.setSingleStep(1.0)
        df.addRow("LO Frequency:", self.lo_input)

        self.bw_input = QDoubleSpinBox()
        self.bw_input.setRange(0.2, 56.0)
        self.bw_input.setDecimals(1)
        self.bw_input.setSuffix("  MHz")
        self.bw_input.setValue(settings.rx_rf_bandwidth / 1e6)
        df.addRow("RF Bandwidth:", self.bw_input)

        self.sr_input = QDoubleSpinBox()
        self.sr_input.setRange(0.521, 61.44)
        self.sr_input.setDecimals(3)
        self.sr_input.setSuffix("  MHz")
        self.sr_input.setValue(settings.rx_sample_rate / 1e6)
        df.addRow("Sample Rate:", self.sr_input)

        self.gain_mode = QComboBox()
        self.gain_mode.addItems(["slow_attack", "fast_attack", "manual"])
        self.gain_mode.setCurrentText(settings.gain_control_mode)
        df.addRow("Gain Mode:", self.gain_mode)

        self.gain_input = QSpinBox()
        self.gain_input.setRange(-10, 73)
        self.gain_input.setSuffix("  dB")
        self.gain_input.setValue(settings.rx_gain)
        df.addRow("Manual Gain:", self.gain_input)

        self.loopback_combo = QComboBox()
        self.loopback_combo.addItems(["0  (Disabled)", "1  (Digital)", "2  (RF)"])
        self.loopback_combo.setCurrentIndex(settings.loopback)
        df.addRow("Loopback:", self.loopback_combo)

        self.lo_offset_spin = QDoubleSpinBox()
        self.lo_offset_spin.setRange(-5000.0, 5000.0)
        self.lo_offset_spin.setDecimals(1)
        self.lo_offset_spin.setSuffix("  kHz")
        self.lo_offset_spin.setSingleStep(100.0)
        self.lo_offset_spin.setValue(settings.LO_OFFSET_KHZ)
        self.lo_offset_spin.setToolTip(
            "Offset added to rx_lo so the DC spike falls outside the band of interest."
        )
        df.addRow("LO Offset:", self.lo_offset_spin)

        self.apply_dev_btn = QPushButton("Apply Device Settings")
        self.apply_dev_btn.clicked.connect(self._on_apply_device)
        df.addRow(self.apply_dev_btn)

        dev.setLayout(df)
        root.addWidget(dev)

        # PFB Settings
        pfb = QGroupBox("PFB Settings")
        pf = QFormLayout()

        self.pfb_enable = QCheckBox("Enable PFB")
        self.pfb_enable.setChecked(settings.PFB_ENABLE)
        self.pfb_enable.toggled.connect(self._on_pfb_enable_toggled)
        pf.addRow(self.pfb_enable)

        self.fft_size = QComboBox()
        for s in (256, 512, 1024, 2048, 4096, 8192, 16384, 32768):
            self.fft_size.addItem(str(s), s)
        self.fft_size.setCurrentText(str(settings.P))
        pf.addRow("FFT / Frame Size:", self.fft_size)

        self.taps_input = QSpinBox()
        self.taps_input.setRange(2, 32)
        self.taps_input.setValue(settings.M)
        pf.addRow("Taps per Branch (M):", self.taps_input)

        self.window_combo = QComboBox()
        self.window_combo.addItems(["hamming", "hann", "blackman-harris", "kaiser"])
        self.window_combo.setCurrentText(settings.PFB_WINDOW)
        pf.addRow("Window:", self.window_combo)

        self.fftshift_chk = QCheckBox("FFT Shift (center DC)")
        self.fftshift_chk.setChecked(settings.PFB_FFTSHIFT)
        pf.addRow(self.fftshift_chk)

        self.dc_notch_spin = QDoubleSpinBox()
        self.dc_notch_spin.setRange(0.0, 500.0)
        self.dc_notch_spin.setDecimals(1)
        self.dc_notch_spin.setSuffix("  kHz")
        self.dc_notch_spin.setSingleStep(5.0)
        self.dc_notch_spin.setValue(settings.DC_NOTCH_KHZ)
        self.dc_notch_spin.setToolTip(
            "Zero ±N kHz of FFT bins around DC to suppress the LO leakage spike (0 = disabled)."
        )
        pf.addRow("DC Notch Width:", self.dc_notch_spin)

        self.apply_pfb_btn = QPushButton("Apply PFB Settings")
        self.apply_pfb_btn.clicked.connect(self._on_apply_pfb)
        pf.addRow(self.apply_pfb_btn)

        pfb.setLayout(pf)
        root.addWidget(pfb)

        # UV plane plotting and correlation settings
        vis = QGroupBox("Plot Visibility")
        vl = QVBoxLayout()

        lbl = QLabel("IQ Time Domain")
        lbl.setStyleSheet("font-weight:bold; margin-top:2px;")
        vl.addWidget(lbl)

        iq_comp_row = QHBoxLayout()
        iq_comp_row.addWidget(QLabel("Component:"))
        self.iq_component = QComboBox()
        self.iq_component.addItems(["I + Q", "I Only", "Q Only"])
        self.iq_component.currentIndexChanged.connect(lambda *_: self.plot_selection_changed.emit())
        iq_comp_row.addWidget(self.iq_component)
        vl.addLayout(iq_comp_row)

        self.iq_checks = {}
        for i in range(4):
            cb = QCheckBox(f"IQ Channel {i}")
            cb.setChecked(True)
            cb.stateChanged.connect(lambda *_: self.plot_selection_changed.emit())
            self.iq_checks[i] = cb
            vl.addWidget(cb)

        lbl2 = QLabel("PFB Spectrum")
        lbl2.setStyleSheet("font-weight:bold; margin-top:4px;")
        vl.addWidget(lbl2)
        self.pfb_checks = {}
        for i in range(4):
            cb = QCheckBox(f"PFB Channel {i}")
            cb.setChecked(True)
            cb.stateChanged.connect(lambda *_: self.plot_selection_changed.emit())
            self.pfb_checks[i] = cb
            vl.addWidget(cb)

        lbl3 = QLabel("Correlations")
        lbl3.setStyleSheet("font-weight:bold; margin-top:4px;")
        vl.addWidget(lbl3)
        self.corr_checks = {}
        for key in CORR_KEYS:
            a, b = int(key[0]), int(key[1])
            label = f"Auto {a}" if a == b else f"Cross {a}×{b}"
            cb = QCheckBox(label)
            cb.setChecked(True)
            cb.stateChanged.connect(lambda *_: self.plot_selection_changed.emit())
            self.corr_checks[key] = cb
            vl.addWidget(cb)

        # Quick select buttons
        row1 = QHBoxLayout()
        b_all = QPushButton("All")
        b_all.clicked.connect(lambda: self._set_all(True))
        b_none = QPushButton("None")
        b_none.clicked.connect(lambda: self._set_all(False))
        row1.addWidget(b_all)
        row1.addWidget(b_none)
        vl.addLayout(row1)

        row2 = QHBoxLayout()
        b_iq = QPushButton("IQ Only")
        b_iq.clicked.connect(self._sel_iq)
        b_pfb = QPushButton("PFB Only")
        b_pfb.clicked.connect(self._sel_pfb)
        b_corr = QPushButton("Corr Only")
        b_corr.clicked.connect(self._sel_corr)
        row2.addWidget(b_iq)
        row2.addWidget(b_pfb)
        row2.addWidget(b_corr)
        vl.addLayout(row2)

        row3 = QHBoxLayout()
        self.uv_btn = QPushButton("UV Plane")
        row3.addWidget(self.uv_btn)
        vl.addLayout(row3)

        vis.setLayout(vl)
        root.addWidget(vis)

        # Plot display settings
        disp = QGroupBox("Display")
        dlf = QFormLayout()
        self.interval_spin = QDoubleSpinBox()
        self.interval_spin.setRange(0.05, 5.0)
        self.interval_spin.setDecimals(2)
        self.interval_spin.setSuffix("  s")
        self.interval_spin.setSingleStep(0.05)
        self.interval_spin.setValue(settings.PLOT_INTERVAL)
        dlf.addRow("Update Interval:", self.interval_spin)

        self.waterfall_chk = QCheckBox("Waterfall mode (Corr)")
        self.waterfall_chk.setChecked(False)
        self.waterfall_chk.toggled.connect(lambda *_: self.display_settings_changed.emit())
        dlf.addRow(self.waterfall_chk)

        self.waterfall_depth = QSpinBox()
        self.waterfall_depth.setRange(16, 512)
        self.waterfall_depth.setValue(100)
        self.waterfall_depth.setSuffix("  rows")
        self.waterfall_depth.setSingleStep(16)
        self.waterfall_depth.setToolTip("Number of time-slices kept in the waterfall history")
        dlf.addRow("Waterfall Depth:", self.waterfall_depth)

        # Sequential / scientific colormaps suitable for spectrograms & dirty images
        _CMAP_CHOICES = [
            "inferno", "magma", "plasma", "viridis", "cividis", "turbo",
            "jet", "hot", "cubehelix", "gray", "bone", "afmhot",
        ]

        self.waterfall_cmap = QComboBox()
        self.waterfall_cmap.addItems(_CMAP_CHOICES)
        self.waterfall_cmap.setCurrentText("inferno")
        self.waterfall_cmap.setToolTip("Colormap used for waterfall (Corr) plots")
        self.waterfall_cmap.currentIndexChanged.connect(lambda *_: self.display_settings_changed.emit())
        dlf.addRow("Waterfall Colormap:", self.waterfall_cmap)

        self.dirty_cmap = QComboBox()
        self.dirty_cmap.addItems(_CMAP_CHOICES)
        self.dirty_cmap.setCurrentText("inferno")
        self.dirty_cmap.setToolTip("Colormap used for the Dirty Image (2D IFFT)")
        self.dirty_cmap.currentIndexChanged.connect(lambda *_: self.display_settings_changed.emit())
        dlf.addRow("Dirty Image Colormap:", self.dirty_cmap)

        self.corr_avg_chk = QCheckBox("Use Integrated (Corr plots)")
        self.corr_avg_chk.setChecked(True)
        self.corr_avg_chk.setToolTip("Plot integrated/averaged correlations instead of instantaneous")
        self.corr_avg_chk.stateChanged.connect(lambda *_: self.display_settings_changed.emit())
        dlf.addRow(self.corr_avg_chk)

        self.uv_phase_chk = QCheckBox("UV colour = Phase (else Amplitude)")
        self.uv_phase_chk.setChecked(False)
        self.uv_phase_chk.toggled.connect(lambda *_: self.display_settings_changed.emit())
        dlf.addRow(self.uv_phase_chk)

        disp.setLayout(dlf)
        root.addWidget(disp)

        # Integration & UV Plane
        intg = QGroupBox("Integration & UV Plane")
        intf = QFormLayout()

        self.int_count_spin = QSpinBox()
        self.int_count_spin.setRange(1, 100000)
        self.int_count_spin.setValue(settings.INTEGRATION_COUNT)
        self.int_count_spin.setSuffix("  frames")
        self.int_count_spin.setSingleStep(10)
        intf.addRow("Integration Count:", self.int_count_spin)

        self.ifft_grid_combo = QComboBox()
        for n in (32, 64, 128, 256, 512, 1024, 2048, 4096):
            self.ifft_grid_combo.addItem(f"{n} × {n}", n)
        # set default to current settings value (or nearest)
        _default_idx = self.ifft_grid_combo.findData(int(settings.IFFT_GRID_SIZE))
        if _default_idx < 0:
            _default_idx = self.ifft_grid_combo.findData(128)
        self.ifft_grid_combo.setCurrentIndex(max(_default_idx, 0))
        self.ifft_grid_combo.setToolTip(
            "Dirty-image IFFT grid resolution (N×N).\n"
            "Larger → finer angular resolution but slower; applied on next integration."
        )
        intf.addRow("IFFT Resolution:", self.ifft_grid_combo)

        self.source_ra_spin = QDoubleSpinBox()
        self.source_ra_spin.setRange(0.0, 360.0)
        self.source_ra_spin.setDecimals(4)
        self.source_ra_spin.setSuffix("  °")
        self.source_ra_spin.setSingleStep(0.1)
        self.source_ra_spin.setValue(getattr(settings, "SOURCE_RA_DEG", 0.0))
        self.source_ra_spin.setToolTip(
            "Right ascension of the phase-tracking center.\n"
            "Hour angle H = LST - RA. Set to 0 for transit/drift-scan mode."
        )
        intf.addRow("Source RA:", self.source_ra_spin)

        self.source_dec_spin = QDoubleSpinBox()
        self.source_dec_spin.setRange(-90.0, 90.0)
        self.source_dec_spin.setDecimals(4)
        self.source_dec_spin.setSuffix("  °")
        self.source_dec_spin.setSingleStep(0.1)
        self.source_dec_spin.setValue(getattr(settings, "OBSERVATION_DECLINATION_DEG", 0.0))
        self.source_dec_spin.setToolTip(
            "Declination of the phase-tracking center.\n"
            "For zenith transit, set this equal to the observatory latitude."
        )
        intf.addRow("Source Dec:", self.source_dec_spin)

        self.fringe_stop_chk = QCheckBox("Fringe-Stop (track source phase center)")
        self.fringe_stop_chk.setChecked(True)
        self.fringe_stop_chk.setToolTip(
            "Apply  V' = V · exp(-j 2π w)  per channel before UV accumulation.\n"
            "Required to keep coherence on a tracked source as Earth rotates."
        )
        intf.addRow(self.fringe_stop_chk)

        self.autocorr_norm_cross_chk = QCheckBox("Auto-Corr Normalize — Crosses  (Vᵢⱼ / √(Vᵢᵢ Vⱼⱼ))")
        self.autocorr_norm_cross_chk.setChecked(True)
        self.autocorr_norm_cross_chk.setToolTip(
            "Divide each cross-corr by √(auto_i · auto_j) so cross visibilities become\n"
            "unitless coherence values in [0, 1], independent of per-channel gain.\n"
            "Recommended ON."
        )
        intf.addRow(self.autocorr_norm_cross_chk)

        self.autocorr_norm_autos_chk = QCheckBox("Auto-Corr Normalize — Autos  (Vᵢᵢ / |Vᵢᵢ|)")
        self.autocorr_norm_autos_chk.setChecked(False)
        self.autocorr_norm_autos_chk.setToolTip(
            "Flatten auto-correlation spectra to unity per channel.\n"
            "Leave OFF to preserve passband shape in the spectrum / waterfall plots.\n"
            "Turn ON only if you want autos plotted as coherence (always ~1)."
        )
        intf.addRow(self.autocorr_norm_autos_chk)

        # ── RFI flagging (MAD on auto-power) ──
        self.rfi_flag_chk = QCheckBox("RFI Flagging  (MAD on autos → mask all baselines)")
        self.rfi_flag_chk.setChecked(True)
        self.rfi_flag_chk.setToolTip(
            "Per integration: build a per-channel flag mask from the auto-corr\n"
            "power spectra using Median Absolute Deviation (robust against the\n"
            "RFI itself biasing the threshold). Channels deviating by more than\n"
            "N·σ from the median are zeroed in every baseline before normalisation.\n"
            "Catches AD9361 fractional-N spurs (which move every boot) plus\n"
            "narrowband external interference, with no manual configuration."
        )
        intf.addRow(self.rfi_flag_chk)

        self.rfi_sigma_spin = QDoubleSpinBox()
        self.rfi_sigma_spin.setRange(2.0, 20.0)
        self.rfi_sigma_spin.setDecimals(1)
        self.rfi_sigma_spin.setSingleStep(0.5)
        self.rfi_sigma_spin.setValue(5.0)
        self.rfi_sigma_spin.setSuffix("  σ")
        self.rfi_sigma_spin.setToolTip(
            "Threshold above the robust noise estimate at which a channel is flagged.\n"
            "5σ is a good default; lower = more aggressive (may clip weak sky lines),\n"
            "higher = only flags the most egregious spurs."
        )
        intf.addRow("RFI Threshold:", self.rfi_sigma_spin)

        self.rfi_status_lbl = QLabel("Flagged: —")
        self.rfi_status_lbl.setToolTip("Fraction of frequency channels flagged in the latest integration.")
        intf.addRow("", self.rfi_status_lbl)

        # 4 antenna positions (East, North) — one per RX channel
        self.ant_east = []
        self.ant_north = []
        for ai in range(4):
            e = QDoubleSpinBox()
            e.setRange(-1000, 1000); e.setDecimals(2); e.setSuffix(" m")
            e.setValue(settings.ANTENNA_POSITIONS_ENU[ai][0] if ai < len(settings.ANTENNA_POSITIONS_ENU) else 0.0)
            intf.addRow(f"Ant {ai} East:", e)
            self.ant_east.append(e)
            n = QDoubleSpinBox()
            n.setRange(-1000, 1000); n.setDecimals(2); n.setSuffix(" m")
            n.setValue(settings.ANTENNA_POSITIONS_ENU[ai][1] if ai < len(settings.ANTENNA_POSITIONS_ENU) else 0.0)
            intf.addRow(f"Ant {ai} North:", n)
            self.ant_north.append(n)

        self.apply_corr_btn = QPushButton("Apply Integration Settings")
        self.apply_corr_btn.clicked.connect(self._on_apply_corr)
        intf.addRow(self.apply_corr_btn)

        self.reset_avg_btn = QPushButton("Reset Averages")
        self.reset_avg_btn.clicked.connect(self._on_reset_avg)
        intf.addRow(self.reset_avg_btn)

        self.clear_uv_btn = QPushButton("Clear UV Data")
        intf.addRow(self.clear_uv_btn)

        self.save_fits_btn = QPushButton("💾  Save UV to FITS")
        intf.addRow(self.save_fits_btn)

        self.save_dirty_fits_btn = QPushButton("🖼  Save Dirty Image to FITS")
        self.save_dirty_fits_btn.setToolTip(
            "Export the current dirty image as a standard FITS file with WCS\n"
            "headers (CTYPE RA---SIN/DEC--SIN). Compatible with DS9, CASA,\n"
            "AIPS, astropy, and the standalone CLEAN app."
        )
        intf.addRow(self.save_dirty_fits_btn)

        self.reset_defaults_btn = QPushButton("↻  Reset All Settings to Defaults")
        self.reset_defaults_btn.setToolTip(
            "Discard the saved session and restore every UI control to the\n"
            "factory defaults from settings.py. Takes effect immediately;\n"
            "click each Apply button to push the new values to the workers."
        )
        self.reset_defaults_btn.clicked.connect(self._reset_to_defaults)
        intf.addRow(self.reset_defaults_btn)

        intg.setLayout(intf)
        root.addWidget(intg)

        # Calibration (Fringe Fitting)
        calg = QGroupBox("Calibration (Fringe Fitting)")
        calf = QFormLayout()

        self.fringe_fit_btn = QPushButton("🎯  Fringe Fit (Calibrate)")
        self.fringe_fit_btn.setToolTip(
            "Compute delay & phase offsets from current averaged cross-spectra.\n"
            "Point at a strong unresolved source first. Does NOT touch hardware."
        )
        calf.addRow(self.fringe_fit_btn)

        self.clear_cal_btn = QPushButton("Clear Calibration")
        self.clear_cal_btn.setToolTip("Remove fringe-fit corrections — return to raw visibilities")
        calf.addRow(self.clear_cal_btn)

        self.cal_status_label = QLabel("No calibration applied")
        self.cal_status_label.setWordWrap(True)
        self.cal_status_label.setStyleSheet("color: #aaaaaa; font-size: 11px;")
        calf.addRow("Status:", self.cal_status_label)

        calg.setLayout(calf)
        root.addWidget(calg)

        root.addStretch()

        # ── persistent settings (QSettings) ──
        # Built AFTER all widgets exist so the registry can reference them.
        # Loads the last session's values, overriding the factory defaults
        # populated above from settings.py. Saved on MainWindow.closeEvent.
        self._qs = QSettings("FX_Correlator", "FX_Correlator")
        self._build_persistent_registry()
        self._load_persistent()

        # initial state of pfb-dependent checkboxes
        # (run AFTER persistent load so it reflects the restored pfb_enable)
        self._on_pfb_enable_toggled(self.pfb_enable.isChecked())

    # ── persistent settings ──
    # Each entry: (key, widget, default_value, kind)
    #   kind ∈ {"double", "int", "bool", "text", "combo_data_int"}
    def _build_persistent_registry(self):
        S = settings
        ant = S.ANTENNA_POSITIONS_ENU
        reg = [
            # device
            ("device/rx_lo_mhz",          self.lo_input,            S.rx_lo / 1e6,          "double"),
            ("device/rf_bw_mhz",          self.bw_input,            S.rx_rf_bandwidth / 1e6,"double"),
            ("device/sample_rate_mhz",    self.sr_input,            S.rx_sample_rate / 1e6, "double"),
            ("device/gain_mode",          self.gain_mode,           S.gain_control_mode,    "text"),
            ("device/gain_db",            self.gain_input,          S.rx_gain,              "int"),
            ("device/lo_offset_khz",      self.lo_offset_spin,      S.LO_OFFSET_KHZ,        "double"),
            # pfb
            ("pfb/enabled",               self.pfb_enable,          S.PFB_ENABLE,           "bool"),
            ("pfb/fft_size",              self.fft_size,            S.P,                    "combo_data_int"),
            ("pfb/taps_M",                self.taps_input,          S.M,                    "int"),
            ("pfb/window",                self.window_combo,        S.PFB_WINDOW,           "text"),
            ("pfb/fftshift",              self.fftshift_chk,        S.PFB_FFTSHIFT,         "bool"),
            ("pfb/dc_notch_khz",          self.dc_notch_spin,       S.DC_NOTCH_KHZ,         "double"),
            # display
            ("display/interval_s",        self.interval_spin,       S.PLOT_INTERVAL,        "double"),
            ("display/waterfall_mode",    self.waterfall_chk,       False,                  "bool"),
            ("display/waterfall_depth",   self.waterfall_depth,     100,                    "int"),
            ("display/waterfall_cmap",    self.waterfall_cmap,      "inferno",              "text"),
            ("display/dirty_cmap",        self.dirty_cmap,          "inferno",              "text"),
            ("display/use_integrated",    self.corr_avg_chk,        True,                   "bool"),
            ("display/uv_phase_color",    self.uv_phase_chk,        False,                  "bool"),
            # corr / uv
            ("corr/integration_count",    self.int_count_spin,      S.INTEGRATION_COUNT,    "int"),
            ("corr/ifft_grid_size",       self.ifft_grid_combo,     int(S.IFFT_GRID_SIZE),  "combo_data_int"),
            ("corr/source_ra_deg",        self.source_ra_spin,      float(S.SOURCE_RA_DEG), "double"),
            ("corr/source_dec_deg",       self.source_dec_spin,     float(S.OBSERVATION_DECLINATION_DEG), "double"),
            ("corr/fringe_stop",          self.fringe_stop_chk,     True,                   "bool"),
            ("corr/autocorr_norm_cross",  self.autocorr_norm_cross_chk, True,               "bool"),
            ("corr/autocorr_norm_autos",  self.autocorr_norm_autos_chk, False,              "bool"),
            ("corr/rfi_flag",             self.rfi_flag_chk,        True,                   "bool"),
            ("corr/rfi_sigma",            self.rfi_sigma_spin,      5.0,                    "double"),
        ]
        # antennas (4 × east/north)
        for ai in range(4):
            e_def = ant[ai][0] if ai < len(ant) else 0.0
            n_def = ant[ai][1] if ai < len(ant) else 0.0
            reg.append((f"ant/{ai}_east",  self.ant_east[ai],  e_def, "double"))
            reg.append((f"ant/{ai}_north", self.ant_north[ai], n_def, "double"))
        self._persistent_widgets = reg

    def _load_persistent(self):
        for key, w, default, kind in self._persistent_widgets:
            try:
                if kind == "double":
                    w.setValue(float(self._qs.value(key, default, type=float)))
                elif kind == "int":
                    w.setValue(int(self._qs.value(key, default, type=int)))
                elif kind == "bool":
                    # QSettings stringifies bools; coerce robustly
                    raw = self._qs.value(key, default)
                    if isinstance(raw, str):
                        raw = raw.lower() in ("true", "1", "yes", "on")
                    w.setChecked(bool(raw))
                elif kind == "text":
                    w.setCurrentText(str(self._qs.value(key, default, type=str)))
                elif kind == "combo_data_int":
                    val = int(self._qs.value(key, default, type=int))
                    idx = w.findData(val)
                    if idx < 0:
                        # try matching the displayed text (e.g. fft_size shows "4096")
                        idx = w.findText(str(val))
                    if idx >= 0:
                        w.setCurrentIndex(idx)
            except Exception as e:
                print(f"persistent load failed for {key}: {e}")

    def _save_persistent(self):
        for key, w, _default, kind in self._persistent_widgets:
            try:
                if kind in ("double", "int"):
                    self._qs.setValue(key, w.value())
                elif kind == "bool":
                    self._qs.setValue(key, bool(w.isChecked()))
                elif kind == "text":
                    self._qs.setValue(key, w.currentText())
                elif kind == "combo_data_int":
                    data = w.currentData()
                    if data is None:
                        # fall back to currentText() parsed as int
                        try:
                            data = int(w.currentText())
                        except Exception:
                            continue
                    self._qs.setValue(key, int(data))
            except Exception as e:
                print(f"persistent save failed for {key}: {e}")
        self._qs.sync()

    def _reset_to_defaults(self):
        self._qs.clear()
        for key, w, default, kind in self._persistent_widgets:
            try:
                if kind == "double":
                    w.setValue(float(default))
                elif kind == "int":
                    w.setValue(int(default))
                elif kind == "bool":
                    w.setChecked(bool(default))
                elif kind == "text":
                    w.setCurrentText(str(default))
                elif kind == "combo_data_int":
                    idx = w.findData(int(default))
                    if idx < 0:
                        idx = w.findText(str(default))
                    if idx >= 0:
                        w.setCurrentIndex(idx)
            except Exception as e:
                print(f"persistent reset failed for {key}: {e}")
        self._qs.sync()
        print("Settings reset to factory defaults — click each Apply button to push to workers.")

    # helpers 
    def _on_pfb_enable_toggled(self, enabled):
        for cb in self.pfb_checks.values():
            cb.setEnabled(enabled)
        for cb in self.corr_checks.values():
            cb.setEnabled(enabled)

    def _set_all(self, state):
        for cb in list(self.iq_checks.values()) + list(self.pfb_checks.values()) + list(self.corr_checks.values()):
            cb.setChecked(state)
        # Always emit — Qt suppresses stateChanged when state is unchanged,
        # which would leave UV-Plane mode stuck if every box was already checked.
        self.plot_selection_changed.emit()

    def _sel_iq(self):
        self._set_all(False)
        for cb in self.iq_checks.values():
            cb.setChecked(True)
        self.plot_selection_changed.emit()

    def _sel_pfb(self):
        self._set_all(False)
        for cb in self.pfb_checks.values():
            cb.setChecked(True)
        self.plot_selection_changed.emit()

    def _sel_corr(self):
        self._set_all(False)
        for cb in self.corr_checks.values():
            cb.setChecked(True)
        self.plot_selection_changed.emit()

    def _on_apply_corr(self):
        self.corr_settings_changed.emit({
            "integration_count": self.int_count_spin.value(),
            "ifft_grid_size": int(self.ifft_grid_combo.currentData()),
            "source_ra_deg": float(self.source_ra_spin.value()),
            "source_dec_deg": float(self.source_dec_spin.value()),
            "fringe_stop": bool(self.fringe_stop_chk.isChecked()),
            "autocorr_norm_cross": bool(self.autocorr_norm_cross_chk.isChecked()),
            "autocorr_norm_autos": bool(self.autocorr_norm_autos_chk.isChecked()),
            "rfi_flag":  bool(self.rfi_flag_chk.isChecked()),
            "rfi_sigma": float(self.rfi_sigma_spin.value()),
            "antenna_positions": [
                (self.ant_east[i].value(), self.ant_north[i].value(), 0.0)
                for i in range(4)
            ],
        })

    def _on_reset_avg(self):
        self.corr_settings_changed.emit({"reset": True})

    def _on_apply_device(self):
        lo_offset_hz = int(self.lo_offset_spin.value() * 1e3)
        target_lo = int(self.lo_input.value() * 1e6)
        actual_lo = target_lo + lo_offset_hz
        self.device_settings_changed.emit({
            "rx_lo": actual_lo,
            "rx_rf_bandwidth": int(self.bw_input.value() * 1e6),
            "rx_sample_rate": int(self.sr_input.value() * 1e6),
            "gain_control_mode": self.gain_mode.currentText(),
            "rx_gain": self.gain_input.value(),
            "loopback": self.loopback_combo.currentIndex(),
            "lo_offset_hz": lo_offset_hz,
        })

    def _on_apply_pfb(self):
        self.pfb_settings_changed.emit({
            "PFB_ENABLE": self.pfb_enable.isChecked(),
            "P": int(self.fft_size.currentData()),
            "M": self.taps_input.value(),
            "PFB_WINDOW": self.window_combo.currentText(),
            "PFB_FFTSHIFT": self.fftshift_chk.isChecked(),
            "DC_NOTCH_KHZ": self.dc_notch_spin.value(),
        })

    def get_plot_selection(self):
        return {
            "iq":   {i: cb.isChecked() for i, cb in self.iq_checks.items()},
            "iq_component": self.iq_component.currentText(),
            "pfb":  {i: cb.isChecked() for i, cb in self.pfb_checks.items()},
            "corr": {k: cb.isChecked() for k, cb in self.corr_checks.items()},
            "corr_averaged": self.corr_avg_chk.isChecked(),
            "waterfall": self.waterfall_chk.isChecked(),
            "waterfall_depth": self.waterfall_depth.value(),
            "waterfall_cmap": self.waterfall_cmap.currentText(),
            "dirty_cmap": self.dirty_cmap.currentText(),
            "uv_phase": self.uv_phase_chk.isChecked(),
        }

#--------------
#  Main window
#--------------
class MainWindow(QMainWindow):
    def __init__(self, num_channels=4, shared=None):
        super().__init__()
        self.num_channels = num_channels
        self.shared = shared or {}
        self._plot_queue = self.shared.get("plot_queue")
        self._corr_plot_queue = self.shared.get("corr_plot_queue")
        self._raw_queue = self.shared.get("raw_queue")
        self._pfb_queue = self.shared.get("pfb_queue")
        self._stop_event = self.shared.get("stop_event")
        self._pfb_config_queue = self.shared.get("pfb_config_queue")
        self._corr_config_queue = self.shared.get("corr_config_queue")
        self._settings_queue = self.shared.get("settings_queue")
        self.setWindowTitle("FX Correlator — Open Radio Interferometry")
        self.setMinimumSize(1280, 800)
        self.resize(1600, 950)

        # cached PFB state (used for freq-axis calculation)
        self._pfb_enable = settings.PFB_ENABLE
        self._P = settings.P
        self._fftshift = settings.PFB_FFTSHIFT
        self._fs = settings.rx_sample_rate

        self._axes = {}
        self._lines = {}
        self._wf_buffers = {}           # (ptype, key) -> 2-D ndarray  (depth, P)
        self._wf_images = {}            # (ptype, key) -> AxesImage
        self._uv_scatter = {}           # ("uv", "amp"|"phase") -> PathCollection
        self._uv_dirty_im = None        # AxesImage for dirty image
        self._uv_grid_size = 128        # NxN grid for UV gridding / IFFT
        self._dirty_result = None       # latest computed dirty image from correlate process
        self._dirty_result_new = False  # flag: new dirty image arrived this tick
        self._needs_redraw = False      # track whether canvas actually needs redraw
        self._uv_showing = False        # cached downsampled UV scatter data from correlate process
        self._uv_scatter_data = None    # dict with u,v,amp,phase (downsampled float32)
        self._waterfall = False
        self._wf_depth = 100
        self._last_pfb_seq = -1
        self._last_avg_seq = -1
        self._last_corr = {}            # cached latest instantaneous correlations
        self._last_avg_corr = {}        # cached latest averaged correlations
        self._active_plots = []
        self._freq_mhz = np.array([])
        self._paused = False

        self._build_ui()
        self._start_timer()
        QTimer.singleShot(0, self._rebuild_plots)

    # UI layout and widget setup
    def _build_ui(self):
        # sidebar
        self.panel = SettingsPanel()
        self.panel.device_settings_changed.connect(self._apply_device)
        self.panel.pfb_settings_changed.connect(self._apply_pfb)
        self.panel.corr_settings_changed.connect(self._apply_corr)
        self.panel.plot_selection_changed.connect(self._on_plot_selection_changed)
        self.panel.display_settings_changed.connect(self._rebuild_plots)
        self.panel.clear_uv_btn.clicked.connect(self._clear_uv_data)
        self.panel.save_fits_btn.clicked.connect(self._save_fits)
        self.panel.save_dirty_fits_btn.clicked.connect(self._save_dirty_fits)
        self.panel.fringe_fit_btn.clicked.connect(self._fringe_fit)
        self.panel.clear_cal_btn.clicked.connect(self._clear_cal)
        self.panel.uv_btn.clicked.connect(self._show_uv)

        scroll = QScrollArea()
        scroll.setWidget(self.panel)
        scroll.setWidgetResizable(True)
        scroll.setHorizontalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
        scroll.setMinimumWidth(290)
        scroll.setMaximumWidth(360)

        dock = QDockWidget("Controls", self)
        dock.setWidget(scroll)
        dock.setFeatures(QDockWidget.DockWidgetMovable | QDockWidget.DockWidgetFloatable)
        self.addDockWidget(Qt.LeftDockWidgetArea, dock)

        # central plot area
        central = QWidget()
        cl = QVBoxLayout(central)
        cl.setContentsMargins(0, 0, 0, 0)
        self.canvas = PlotCanvas(central, dpi=100)
        self.toolbar = NavigationToolbar2QT(self.canvas, central)

        # pause button (sits beside the mpl toolbar)
        toolbar_row = QHBoxLayout()
        toolbar_row.setContentsMargins(0, 0, 0, 0)
        toolbar_row.addWidget(self.toolbar, stretch=1)
        self._pause_btn = QPushButton("⏸  Pause")
        self._pause_btn.setCheckable(True)
        self._pause_btn.setFixedWidth(100)
        self._pause_btn.setStyleSheet(
            "QPushButton:checked { background-color: #b85c00; color: white; }"
        )
        self._pause_btn.toggled.connect(self._toggle_pause)
        toolbar_row.addWidget(self._pause_btn)

        cl.addLayout(toolbar_row)
        cl.addWidget(self.canvas)
        self.setCentralWidget(central)

        # status bar
        self.sbar = QStatusBar()
        self.setStatusBar(self.sbar)
        self._q_labels = {}
        for qname in ("raw", "pfb", "plot", "corr_plot", "settings", "pfb_cfg", "corr_cfg"):
            lbl = QLabel(f"{qname}: 0")
            lbl.setStyleSheet("padding: 0 4px; color: #aaaaaa; font-size: 11px;")
            self.sbar.addPermanentWidget(lbl)
            self._q_labels[qname] = lbl
        self.sbar.showMessage("Ready — waiting for first frame …")

    # timer
    def _start_timer(self):
        self._timer = QTimer(self)
        self._timer.timeout.connect(self._update_plots)
        ms = int(self.panel.interval_spin.value() * 1000)
        self._timer.start(ms)
        self.panel.interval_spin.valueChanged.connect(
            lambda v: self._timer.setInterval(int(v * 1000))
        )

    # plot grid rebuild
    def _rebuild_plots(self):
        sel = self.panel.get_plot_selection()
        self.canvas.fig.clear()
        self._axes.clear()
        self._lines.clear()
        self._wf_images.clear()
        self._uv_scatter.clear()
        self._uv_dirty_im = None
        self._active_plots.clear()

        self._waterfall = sel.get("waterfall", False)
        self._wf_depth = sel.get("waterfall_depth", 100)
        self._iq_component = sel.get("iq_component", "I + Q")
        self._uv_phase = sel.get("uv_phase", False)
        self._corr_averaged = sel.get("corr_averaged", False)

        # collect active plot descriptors
        if self._uv_showing:
            # UV-only mode: show amplitude, optionally phase, and dirty image
            self._active_plots.append(("uv", "amp"))
            if sel.get("uv_phase"):
                self._active_plots.append(("uv", "phase"))
            self._active_plots.append(("uv", "image"))
        else:
            for i in range(4):
                if sel["iq"].get(i):
                    self._active_plots.append(("iq", i))
            if self._pfb_enable:
                for i in range(4):
                    if sel["pfb"].get(i):
                        self._active_plots.append(("pfb", i))
                for k in CORR_KEYS:
                    if sel["corr"].get(k):
                        self._active_plots.append(("corr", k))

        n = len(self._active_plots)
        if n == 0:
            ax = self.canvas.fig.add_subplot(111)
            ax.text(
                0.5, 0.5, "No plots selected",
                ha="center", va="center", fontsize=16, color="#888888",
                transform=ax.transAxes,
            )
            ax.set_xticks([])
            ax.set_yticks([])
            self.canvas.draw_idle()
            return

        # choose grid layout: square-ish for PFB-only or IQ-only, wide otherwise
        ptypes = {p for p, _ in self._active_plots}
        if ptypes <= {"pfb", "iq"} and len(ptypes) == 1:
            cols = math.ceil(math.sqrt(n))
        else:
            cols = min(n, 4)
        rows = math.ceil(n / cols)

        # recompute frequency axis
        freq = np.fft.fftfreq(self._P, d=1.0 / self._fs)
        if self._fftshift:
            freq = np.fft.fftshift(freq)
        self._freq_mhz = freq / 1e6

        f_lo = self._freq_mhz[0]  if len(self._freq_mhz) else 0
        f_hi = self._freq_mhz[-1] if len(self._freq_mhz) else 1

        for idx, (ptype, key) in enumerate(self._active_plots):
            ax = self.canvas.fig.add_subplot(rows, cols, idx + 1)
            self._axes[(ptype, key)] = ax

            use_wf = self._waterfall and ptype == "corr"

            if ptype == "iq":
                if self._iq_component == "I Only":
                    li, = ax.plot([], [], label="I", alpha=0.85)
                    self._lines[(ptype, key)] = (li, None)
                    ax.set_title(f"I Channel {key}", fontsize=9)
                elif self._iq_component == "Q Only":
                    lq, = ax.plot([], [], label="Q", color="tab:orange", alpha=0.85)
                    self._lines[(ptype, key)] = (None, lq)
                    ax.set_title(f"Q Channel {key}", fontsize=9)
                else:
                    li, = ax.plot([], [], label="I", alpha=0.85)
                    lq, = ax.plot([], [], label="Q", alpha=0.85)
                    self._lines[(ptype, key)] = (li, lq)
                    ax.set_title(f"IQ Channel {key}", fontsize=9)
                ax.set_xlabel("Sample")
                ax.legend(loc="upper right")
                ax.grid(True)

            elif ptype == "pfb":
                lp, = ax.plot([], [], color="tab:green", alpha=0.85)
                self._lines[(ptype, key)] = (lp,)
                ax.set_title(f"PFB Ch {key}  (dB)", fontsize=9)
                ax.set_xlabel("Frequency (MHz)")
                ax.grid(True)

            elif ptype == "corr" and not use_wf:
                a, b = int(key[0]), int(key[1])
                tag = f"Auto {a}" if a == b else f"Cross {a}×{b}"
                lc, = ax.plot([], [], color="tab:purple", alpha=0.85)
                self._lines[(ptype, key)] = (lc,)
                ax.set_title(f"{tag}  (dB)", fontsize=9)
                ax.set_xlabel("Frequency (MHz)")
                ax.grid(True)
                # seed with cached data so plot is immediately visible
                src = self._last_avg_corr if self._corr_averaged else self._last_corr
                if src and key in src:
                    row = 10 * np.log10(np.abs(src[key]) + 1e-12)
                    if row.shape[0] == self._freq_mhz.shape[0]:
                        lc.set_data(self._freq_mhz, row)
                        ax.relim()
                        ax.autoscale_view()

            elif ptype == "corr" and use_wf:
                a, b = int(key[0]), int(key[1])
                tag = f"Auto {a}" if a == b else f"Cross {a}×{b}"
                buf = self._wf_buffers.get((ptype, key))
                if buf is None or buf.shape != (self._wf_depth, self._P):
                    buf = np.full((self._wf_depth, self._P), np.nan)
                    self._wf_buffers[(ptype, key)] = buf
                im = ax.imshow(
                    buf,
                    aspect="auto",
                    origin="lower",
                    extent=[f_lo, f_hi, 0, self._wf_depth],
                    cmap=sel.get("waterfall_cmap", "inferno"),
                    interpolation="nearest",
                )
                self._wf_images[(ptype, key)] = im
                ax.set_title(f"{tag}  waterfall (dB)", fontsize=9)
                ax.set_xlabel("Frequency (MHz)")
                ax.set_ylabel("Time (frames)")

            elif ptype == "uv" and key == "image":
                # Dirty image via 2D IFFT of gridded visibilities
                N = self._uv_grid_size
                blank = np.zeros((N, N))
                im = ax.imshow(
                    blank, origin="lower", cmap=sel.get("dirty_cmap", "inferno"),
                    extent=[-1, 1, -1, 1], aspect="equal",
                    interpolation="nearest",
                )
                self._uv_dirty_im = im
                ax.set_title("Dirty Image (2D IFFT)", fontsize=9)
                ax.set_xlabel("l  (direction cosine)")
                ax.set_ylabel("m  (direction cosine)")
                # seed with cached dirty image result if available
                if self._dirty_result is not None:
                    dirty_abs = self._dirty_result["dirty_abs"]
                    lm_extent = self._dirty_result["lm_extent"]
                    im.set_data(dirty_abs)
                    im.set_extent([-lm_extent, lm_extent, -lm_extent, lm_extent])
                    if dirty_abs.max() > 0:
                        im.set_clim(0, dirty_abs.max())

            elif ptype == "uv":
                is_phase = (key == "phase")
                cmap = "twilight" if is_phase else "inferno"
                title = "UV Plane — Phase" if is_phase else "UV Plane — Amplitude"
                # init with a dummy invisible point to avoid empty-array issues
                sc = ax.scatter([0], [0], c=[0], cmap=cmap, s=4, alpha=0.0)
                self._uv_scatter[(ptype, key)] = sc
                ax.set_title(title, fontsize=9)
                ax.set_xlabel("u  (wavelengths)")
                ax.set_ylabel("v  (wavelengths)")
                ax.set_aspect("equal")
                ax.grid(True, alpha=0.3)
                # restore persistent UV data
                if self._uv_scatter_data is not None:
                    sd = self._uv_scatter_data
                    c_data = sd["phase"] if is_phase else np.log10(sd["amp"] + 1e-12)
                    offsets = np.column_stack([sd["u"], sd["v"]])
                    sc.set_offsets(offsets)
                    sc.set_array(c_data)
                    sc.set_alpha(0.8)
                    if c_data.size:
                        sc.set_clim(c_data.min(), c_data.max())
                    span = max(sd["u_max"] - sd["u_min"], 1.0)
                    margin = max(1.0, 0.05 * span)
                    ax.set_xlim(sd["u_min"] - margin, sd["u_max"] + margin)
                    ax.set_ylim(sd["v_min"] - margin, sd["v_max"] + margin)

        self.canvas.fig.suptitle("FX Correlator", fontsize=11)
        self.canvas.fig.tight_layout(rect=[0, 0, 1, 0.96])
        self.canvas.draw_idle()

    # pause toggle
    def _toggle_pause(self, checked):
        self._paused = checked
        self._pause_btn.setText("▶  Resume" if checked else "⏸  Pause")
        self.sbar.showMessage("⏸  Display paused" if checked else "▶  Display resumed")

    # UV view
    def _on_plot_selection_changed(self):
        self._uv_showing = False
        self._rebuild_plots()

    def _show_uv(self):
        self._uv_showing = True
        self._rebuild_plots()

    def _save_dirty_fits(self):
        """Ask the user for a path, then tell correlate_process to write the
        current dirty image as a standard FITS image with WCS headers."""
        path, _ = QFileDialog.getSaveFileName(
            self, "Save Dirty Image as FITS",
            time.strftime("dirty_image_%Y%m%d_%H%M%S.fits"),
            "FITS files (*.fits);;All files (*)",
        )
        if not path:
            return
        if self._corr_config_queue is not None:
            try:
                self._corr_config_queue.put_nowait({"save_dirty_fits": path})
                self.sbar.showMessage(f"Saving dirty image to {path} …")
            except Exception as e:
                QMessageBox.warning(self, "Save Error", f"Could not queue save request: {e}")
        else:
            QMessageBox.warning(self, "Save Error", "Correlator process not connected.")

    def _save_fits(self):
        """Ask the user for a file path, then tell correlate_process to write a FITS file."""
        path, _ = QFileDialog.getSaveFileName(
            self, "Save UV Data as FITS",
            time.strftime("uv_data_%Y%m%d_%H%M%S.fits"),
            "FITS files (*.fits);;All files (*)",
        )
        if not path:
            return
        if self._corr_config_queue is not None:
            try:
                self._corr_config_queue.put_nowait({"save_fits": path})
                self.sbar.showMessage(f"Saving UV data to {path} …")
            except Exception as e:
                QMessageBox.warning(self, "Save Error", f"Could not queue save request: {e}")
        else:
            QMessageBox.warning(self, "Save Error", "Correlator process not connected.")

    def _fringe_fit(self):
        """Request fringe fitting from correlate_process. Does NOT touch hardware."""
        if self._corr_config_queue is not None:
            try:
                self._corr_config_queue.put_nowait({"fringe_fit": True})
                self.sbar.showMessage("🎯  Fringe fit requested — computing from current averaged data …")
            except Exception as e:
                QMessageBox.warning(self, "Calibration Error", str(e))
        else:
            QMessageBox.warning(self, "Calibration Error", "Correlator process not connected.")

    def _clear_cal(self):
        """Removes fringe-fit calibration """
        if self._corr_config_queue is not None:
            try:
                self._corr_config_queue.put_nowait({"clear_cal": True})
                self.panel.cal_status_label.setText("No calibration applied")
                self.panel.cal_status_label.setStyleSheet("color: #aaaaaa; font-size: 11px;")
                self.sbar.showMessage("Calibration cleared")
            except Exception as e:
                QMessageBox.warning(self, "Calibration Error", str(e))

    def _clear_uv_data(self):
        self._uv_scatter_data = None
        self._dirty_result = None
        self._dirty_result_new = False
        if self._corr_config_queue is not None:
            try:
                self._corr_config_queue.put_nowait({"clear_uv": True})
            except Exception:
                pass
        self._rebuild_plots()
        self.sbar.showMessage("UV data cleared")

    # periodic data pull (plot update)
    def _update_plots(self):
        if self._plot_queue is None:
            return

        # update queue-size indicators
        try:
            q_map = {
                "raw": self._raw_queue,
                "pfb": self._pfb_queue,
                "plot": self._plot_queue,
                "corr_plot": self._corr_plot_queue,
                "settings": self._settings_queue,
                "pfb_cfg": self._pfb_config_queue,
                "corr_cfg": self._corr_config_queue,
            }
            for qname, qobj in q_map.items():
                if qobj and qname in self._q_labels:
                    self._q_labels[qname].setText(f"{qname}: {qobj.qsize()}")
        except Exception:
            pass

        # Drain the plot queue (IQ + PFB data)
        pfb_frame = None
        try:
            while True:
                pfb_frame = self._plot_queue.get_nowait()
        except Exception:
            pass

        # Drain the corr plot queue (correlations + UV)
        corr_frame = None
        if self._corr_plot_queue is not None:
            try:
                while True:
                    corr_frame = self._corr_plot_queue.get_nowait()
            except Exception:
                pass

        if (pfb_frame is None and corr_frame is None) or self._paused:
            return

        # extract IQ + PFB fields
        raw = pfb_frame.get("raw") if pfb_frame else None
        pfb = pfb_frame.get("pfb") if pfb_frame else None
        pfb_seq = pfb_frame.get("pfb_seq", -1) if pfb_frame else -1

        # extract correlation fields
        corr = corr_frame.get("correlations", {}) if corr_frame else {}
        avg_corr = corr_frame.get("avg_correlations") if corr_frame else None
        avg_seq = corr_frame.get("avg_seq", -1) if corr_frame else -1

        # cache latest correlation data for instant display on plot switch
        if corr:
            self._last_corr = corr
        if avg_corr:
            self._last_avg_corr = avg_corr

        pfb_new = pfb_seq != self._last_pfb_seq
        avg_new = avg_seq != self._last_avg_seq
        if pfb_new:
            self._last_pfb_seq = pfb_seq
        if avg_new:
            self._last_avg_seq = avg_seq
            # update RFI flagger status label
            ff = corr_frame.get("flagged_frac") if corr_frame else None
            if ff is not None:
                pct = 100.0 * float(ff)
                self.panel.rfi_status_lbl.setText(f"Flagged: {pct:.1f}%")

        self._needs_redraw = False

        for (ptype, key), ax in self._axes.items():
            is_wf = (ptype, key) in self._wf_images

            # skip non-UV plot types when in UV-only mode
            if self._uv_showing and ptype not in ("uv",):
                continue

            # ── IQ (always line mode) ──────────────────────────
            if ptype == "iq":
                lines = self._lines.get((ptype, key))
                if lines is None:
                    continue
                ch = key
                if hasattr(raw, "shape"):
                    if ch >= raw.shape[0]:
                        continue
                    samples = raw[ch]
                elif isinstance(raw, (list, tuple)):
                    if ch >= len(raw):
                        continue
                    samples = np.asarray(raw[ch])
                else:
                    continue
                x = np.arange(len(samples))
                li, lq = lines
                if li is not None:
                    li.set_data(x, np.real(samples))
                if lq is not None:
                    lq.set_data(x, np.imag(samples))
                ax.relim()
                ax.autoscale_view()
                self._needs_redraw = True

            # ── PFB (line plot only) ───────────────────────────
            elif ptype == "pfb" and pfb is not None:
                ch = key
                if ch >= pfb.shape[0]:
                    continue
                row = pfb[ch]                                    # already dB
                lines = self._lines.get((ptype, key))
                if lines and row.shape[0] == self._freq_mhz.shape[0]:
                    lines[0].set_data(self._freq_mhz, row)
                    ax.relim()
                    ax.autoscale_view()
                    self._needs_redraw = True

            # ── Correlations ───────────────────────────────────
            elif ptype == "corr":
                # line plots: show instantaneous or averaged per setting
                src_line = avg_corr if (self._corr_averaged and avg_corr) else corr
                if is_wf:
                    # waterfall: just redraw from pre-accumulated buffer
                    wf_key = (ptype, key)
                    buf = self._wf_buffers.get(wf_key)
                    im = self._wf_images.get(wf_key)
                    if im and buf is not None:
                        im.set_data(buf)
                        finite = buf[np.isfinite(buf)]
                        if finite.size:
                            im.set_clim(vmin=finite.min(), vmax=finite.max())
                        self._needs_redraw = True
                else:
                    if not src_line or key not in src_line:
                        continue
                    row = 10 * np.log10(np.abs(src_line[key]) + 1e-12)
                    lines = self._lines.get((ptype, key))
                    if lines and row.shape[0] == self._freq_mhz.shape[0]:
                        lines[0].set_data(self._freq_mhz, row)
                        ax.relim()
                        ax.autoscale_view()
                        self._needs_redraw = True

        # ── update cached UV data from correlate process ──
        # pre-accumulate waterfall buffers for all corr keys (even when not displayed)
        if avg_new and avg_corr:
            for ckey in CORR_KEYS:
                if ckey in avg_corr:
                    row = 10 * np.log10(np.abs(avg_corr[ckey]) + 1e-12)
                    wf_key = ("corr", ckey)
                    buf = self._wf_buffers.get(wf_key)
                    if buf is not None and row.shape[0] == buf.shape[1]:
                        buf[:-1] = buf[1:]
                        buf[-1] = row
                    elif buf is None or buf.shape[1] != self._P:
                        buf = np.full((self._wf_depth, self._P), np.nan)
                        if row.shape[0] == self._P:
                            buf[-1] = row
                        self._wf_buffers[wf_key] = buf

        # ── extract pre-computed UV scatter + dirty image from correlate process ──
        uv_scatter = corr_frame.get("uv_scatter") if corr_frame else None
        if uv_scatter is not None:
            self._uv_scatter_data = uv_scatter

        dirty_result = corr_frame.get("dirty_result") if corr_frame else None
        if dirty_result is not None:
            self._dirty_result = dirty_result
            self._dirty_result_new = True

        # ── update calibration status display ──
        cal_info = corr_frame.get("cal_info") if corr_frame else None
        if cal_info is not None:
            bl = cal_info.get("baselines", {})
            if cal_info.get("enabled") and bl:
                parts = []
                for bk, cv in sorted(bl.items()):
                    parts.append(f"{bk}: τ={cv['delay_ns']:.1f} ns  φ={cv['phase_deg']:.1f}°")
                self.panel.cal_status_label.setText("✓ Cal ON\n" + "\n".join(parts))
                self.panel.cal_status_label.setStyleSheet("color: #44bb44; font-size: 11px;")
            else:
                self.panel.cal_status_label.setText("No calibration applied")
                self.panel.cal_status_label.setStyleSheet("color: #aaaaaa; font-size: 11px;")

        # Only update UV scatter when new integration data arrived
        if avg_new and self._uv_scatter_data is not None and self._uv_scatter:
            try:
                sd = self._uv_scatter_data
                offsets = np.column_stack([sd["u"], sd["v"]])
                for (ptype, key), sc in self._uv_scatter.items():
                    c_data = sd["phase"] if key == "phase" else np.log10(sd["amp"] + 1e-12)
                    sc.set_offsets(offsets)
                    sc.set_array(c_data)
                    sc.set_alpha(0.8)
                    if c_data.size:
                        sc.set_clim(c_data.min(), c_data.max())
                    ax = self._axes.get((ptype, key))
                    if ax:
                        span = max(sd["u_max"] - sd["u_min"], 1.0)
                        margin = max(1.0, 0.05 * span)
                        ax.set_xlim(sd["u_min"] - margin, sd["u_max"] + margin)
                        ax.set_ylim(sd["v_min"] - margin, sd["v_max"] + margin)
                self._needs_redraw = True
            except Exception as e:
                print(f"UV update error: {e}")

        # display dirty image only when a new result arrives
        if self._dirty_result_new and self._uv_dirty_im is not None and self._dirty_result is not None:
            try:
                ax_img = self._axes.get(("uv", "image"))
                if ax_img:
                    dirty_abs = self._dirty_result["dirty_abs"]
                    lm_extent = self._dirty_result["lm_extent"]
                    self._uv_dirty_im.set_data(dirty_abs)
                    self._uv_dirty_im.set_extent([-lm_extent, lm_extent, -lm_extent, lm_extent])
                    if dirty_abs.max() > 0:
                        self._uv_dirty_im.set_clim(0, dirty_abs.max())
                    ax_img.set_xlabel("l  (rad)")
                    ax_img.set_ylabel("m  (rad)")
                    self._needs_redraw = True
            except Exception as e:
                print(f"Dirty image display error: {e}")
            self._dirty_result_new = False

        if self._needs_redraw:
            ts = time.strftime("%H:%M:%S")
            self.canvas.fig.suptitle(f"FX Correlator — {ts}", fontsize=11)
            self.canvas.draw_idle()
        else:
            ts = time.strftime("%H:%M:%S")

        self.sbar.showMessage(
            f"Last update: {ts}  |  PFB: {'ON' if self._pfb_enable else 'OFF'}  |  "
            f"Plots: {len(self._active_plots)}  |  "
            f"LO: {self._fs / 1e6:.3f} MSps"
        )

    # apply device settings
    def _apply_device(self, cfg):
        if self._settings_queue is None:
            self.sbar.showMessage("⚠  No settings queue — settings not applied")
            return
        try:
            self._settings_queue.put_nowait(cfg)

            # keep local settings module in sync for freq-axis recalc
            settings.rx_lo = cfg["rx_lo"]
            settings.rx_rf_bandwidth = cfg["rx_rf_bandwidth"]
            settings.rx_sample_rate = cfg["rx_sample_rate"]
            settings.gain_control_mode = cfg["gain_control_mode"]
            settings.rx_gain = cfg["rx_gain"]
            settings.loopback = cfg["loopback"]

            if cfg["rx_sample_rate"] != self._fs:
                self._fs = cfg["rx_sample_rate"]
                self._rebuild_plots()

            self.sbar.showMessage(
                f"✓  Device settings queued — LO {cfg['rx_lo']/1e6:.3f} MHz  "
                f"BW {cfg['rx_rf_bandwidth']/1e6:.1f} MHz  "
                f"Rate {cfg['rx_sample_rate']/1e6:.3f} MSps"
            )
        except Exception as exc:
            QMessageBox.warning(self, "Device Error", str(exc))
            self.sbar.showMessage(f"⚠  Device error: {exc}")

    # apply PFB settings
    def _apply_pfb(self, cfg):
        try:
            new_p = cfg["P"]
            new_m = cfg["M"]
            new_win = cfg["PFB_WINDOW"]

            # keep local settings module in sync (used for freq-axis, etc.)
            settings.PFB_ENABLE = cfg["PFB_ENABLE"]
            settings.P = new_p
            settings.M = new_m
            settings.PFB_WINDOW = new_win
            settings.PFB_FFTSHIFT = cfg["PFB_FFTSHIFT"]
            settings.DC_NOTCH_KHZ = cfg.get("DC_NOTCH_KHZ", 0)
            settings.FRAME_SIZE = new_p
            settings.BUFFER_SIZE = new_p * 100

            # send DC notch setting to correlate_process
            if self._corr_config_queue is not None:
                try:
                    self._corr_config_queue.put_nowait({"dc_notch_khz": settings.DC_NOTCH_KHZ})
                except Exception:
                    pass

            # send the full PFB config to pfb_process via IPC queue
            if self._pfb_config_queue is not None:
                try:
                    self._pfb_config_queue.put_nowait(cfg)
                except Exception:
                    pass

            # tell data_read about the new frame size and buffer size
            if self._settings_queue is not None:
                try:
                    self._settings_queue.put_nowait({
                        "frame_size": new_p,
                        "rx_buffer_size": new_p * 100,
                    })
                except Exception:
                    pass

            # flush stale frames from the plot queue so old-sized data
            # doesn't get plotted against the new frequency axis
            if self._plot_queue is not None:
                try:
                    while True:
                        self._plot_queue.get_nowait()
                except Exception:
                    pass

            # update local cached state & rebuild plots
            self._pfb_enable = cfg["PFB_ENABLE"]
            self._P = new_p
            self._fftshift = cfg["PFB_FFTSHIFT"]
            self._wf_buffers.clear()  # old size data is invalid
            self._last_pfb_seq = -1
            self._last_avg_seq = -1
            self._rebuild_plots()

            self.sbar.showMessage(
                f"✓  PFB {'enabled' if cfg['PFB_ENABLE'] else 'disabled'} — "
                f"P={new_p}  M={new_m}  window={new_win}"
            )
        except Exception as exc:
            QMessageBox.warning(self, "PFB Error", str(exc))
            self.sbar.showMessage(f"⚠  PFB error: {exc}")

    # apply correlator / integration settings
    def _apply_corr(self, cfg):
        if self._corr_config_queue is None:
            return
        try:
            self._corr_config_queue.put_nowait(cfg)
            if "integration_count" in cfg:
                settings.INTEGRATION_COUNT = cfg["integration_count"]
            if "antenna_positions" in cfg:
                settings.ANTENNA_POSITIONS_ENU = cfg["antenna_positions"]
            self.sbar.showMessage(
                f"✓  Correlator settings updated — "
                f"integration={cfg.get('integration_count', '?')}  "
                f"{'RESET' if cfg.get('reset') else ''}"
            )
        except Exception as exc:
            self.sbar.showMessage(f"⚠  Correlator error: {exc}")

    # handle resize
    def resizeEvent(self, event):
        super().resizeEvent(event)
        try:
            self.canvas.fig.tight_layout(rect=[0, 0, 1, 0.96])
            self.canvas.draw_idle()
        except Exception:
            pass

    # clean shutdown
    def closeEvent(self, event):
        try:
            self.panel._save_persistent()
        except Exception as e:
            print(f"Persistent settings save failed: {e}")
        self._timer.stop()
        if self._stop_event is not None:
            self._stop_event.set()
        event.accept()


#  Dark color palette
def _apply_dark_palette(app: QApplication):
    p = QPalette()
    p.setColor(QPalette.Window,          QColor(53, 53, 53))
    p.setColor(QPalette.WindowText,      QColor(235, 235, 235))
    p.setColor(QPalette.Base,            QColor(42, 42, 42))
    p.setColor(QPalette.AlternateBase,   QColor(66, 66, 66))
    p.setColor(QPalette.ToolTipBase,     QColor(25, 25, 25))
    p.setColor(QPalette.ToolTipText,     QColor(235, 235, 235))
    p.setColor(QPalette.Text,            QColor(235, 235, 235))
    p.setColor(QPalette.Button,          QColor(53, 53, 53))
    p.setColor(QPalette.ButtonText,      QColor(235, 235, 235))
    p.setColor(QPalette.BrightText,      QColor(255, 50, 50))
    p.setColor(QPalette.Link,            QColor(42, 130, 218))
    p.setColor(QPalette.Highlight,       QColor(42, 130, 218))
    p.setColor(QPalette.HighlightedText, QColor(35, 35, 35))
    p.setColor(QPalette.Disabled, QPalette.WindowText, QColor(127, 127, 127))
    p.setColor(QPalette.Disabled, QPalette.Text,       QColor(127, 127, 127))
    p.setColor(QPalette.Disabled, QPalette.ButtonText, QColor(127, 127, 127))
    app.setPalette(p)
    app.setStyleSheet(
        "QToolTip { color: #ebebeb; background-color: #2b2b2b; border: 1px solid #555; }"
    )


# Public entry point for launching the UI
def run_ui(num_channels=4, shared=None):
    app = QApplication.instance()
    if app is None:
        app = QApplication(sys.argv)

    app.setStyle("Fusion")
    _apply_dark_palette(app)

    win = MainWindow(num_channels=num_channels, shared=shared)
    win.show()
    return app.exec_()
