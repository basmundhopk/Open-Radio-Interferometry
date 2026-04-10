"""
FX Correlator GUI — PyQt5 + Matplotlib
=======================================
Full replacement for run_plot_loop().  Provides:
  • live plot display with selectable panels (IQ / PFB / Correlations)
  • runtime SDR device settings (LO, bandwidth, sample-rate, gain …)
  • runtime PFB channelizer settings (enable, FFT size, taps, window …)
  • dark Fusion theme
"""

import sys
import math
import time
import numpy as np

# ── Matplotlib backend (must be set before any other mpl import) ──
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
)
from PyQt5.QtCore import Qt, QTimer, pyqtSignal
from PyQt5.QtGui import QPalette, QColor

import settings
from pfb_coeffs import generate_win_coeffs_np

# ── Dark matplotlib rc overrides ──────────────────────────────
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
    plot_selection_changed = pyqtSignal()

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

        self.apply_dev_btn = QPushButton("Apply Device Settings")
        self.apply_dev_btn.clicked.connect(self._on_apply_device)
        df.addRow(self.apply_dev_btn)

        dev.setLayout(df)
        root.addWidget(dev)

        # ── PFB Channelizer Settings ──────────────────────────
        pfb = QGroupBox("PFB Channelizer")
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
        self.window_combo.addItems(["hamming", "hann"])
        self.window_combo.setCurrentText(settings.PFB_WINDOW)
        pf.addRow("Window:", self.window_combo)

        self.fftshift_chk = QCheckBox("FFT Shift (center DC)")
        self.fftshift_chk.setChecked(settings.PFB_FFTSHIFT)
        pf.addRow(self.fftshift_chk)

        self.apply_pfb_btn = QPushButton("Apply PFB Settings")
        self.apply_pfb_btn.clicked.connect(self._on_apply_pfb)
        pf.addRow(self.apply_pfb_btn)

        pfb.setLayout(pf)
        root.addWidget(pfb)

        # ── Plot Visibility ───────────────────────────────────
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

        # quick-select buttons
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

        vis.setLayout(vl)
        root.addWidget(vis)

        # ── Display Settings ──────────────────────────────────
        disp = QGroupBox("Display")
        dlf = QFormLayout()
        self.interval_spin = QDoubleSpinBox()
        self.interval_spin.setRange(0.05, 5.0)
        self.interval_spin.setDecimals(2)
        self.interval_spin.setSuffix("  s")
        self.interval_spin.setSingleStep(0.05)
        self.interval_spin.setValue(settings.PLOT_INTERVAL)
        dlf.addRow("Update Interval:", self.interval_spin)

        self.waterfall_chk = QCheckBox("Waterfall mode (PFB / Corr)")
        self.waterfall_chk.setChecked(False)
        self.waterfall_chk.toggled.connect(lambda *_: self.plot_selection_changed.emit())
        dlf.addRow(self.waterfall_chk)

        self.waterfall_depth = QSpinBox()
        self.waterfall_depth.setRange(16, 512)
        self.waterfall_depth.setValue(100)
        self.waterfall_depth.setSuffix("  rows")
        self.waterfall_depth.setSingleStep(16)
        self.waterfall_depth.setToolTip("Number of time-slices kept in the waterfall history")
        dlf.addRow("Waterfall Depth:", self.waterfall_depth)

        disp.setLayout(dlf)
        root.addWidget(disp)

        root.addStretch()

        # initial state of pfb-dependent checkboxes
        self._on_pfb_enable_toggled(self.pfb_enable.isChecked())

    # ── helpers ────────────────────────────────────────────────
    def _on_pfb_enable_toggled(self, enabled):
        for cb in self.pfb_checks.values():
            cb.setEnabled(enabled)
        for cb in self.corr_checks.values():
            cb.setEnabled(enabled)

    def _set_all(self, state):
        for cb in list(self.iq_checks.values()) + list(self.pfb_checks.values()) + list(self.corr_checks.values()):
            cb.setChecked(state)

    def _sel_iq(self):
        self._set_all(False)
        for cb in self.iq_checks.values():
            cb.setChecked(True)

    def _sel_pfb(self):
        self._set_all(False)
        for cb in self.pfb_checks.values():
            cb.setChecked(True)

    def _sel_corr(self):
        self._set_all(False)
        for cb in self.corr_checks.values():
            cb.setChecked(True)

    def _on_apply_device(self):
        self.device_settings_changed.emit({
            "rx_lo": int(self.lo_input.value() * 1e6),
            "rx_rf_bandwidth": int(self.bw_input.value() * 1e6),
            "rx_sample_rate": int(self.sr_input.value() * 1e6),
            "gain_control_mode": self.gain_mode.currentText(),
            "rx_gain": self.gain_input.value(),
            "loopback": self.loopback_combo.currentIndex(),
        })

    def _on_apply_pfb(self):
        self.pfb_settings_changed.emit({
            "PFB_ENABLE": self.pfb_enable.isChecked(),
            "P": int(self.fft_size.currentData()),
            "M": self.taps_input.value(),
            "PFB_WINDOW": self.window_combo.currentText(),
            "PFB_FFTSHIFT": self.fftshift_chk.isChecked(),
        })

    def get_plot_selection(self):
        return {
            "iq":   {i: cb.isChecked() for i, cb in self.iq_checks.items()},
            "iq_component": self.iq_component.currentText(),  # "I + Q", "I Only", "Q Only"
            "pfb":  {i: cb.isChecked() for i, cb in self.pfb_checks.items()},
            "corr": {k: cb.isChecked() for k, cb in self.corr_checks.items()},
            "waterfall": self.waterfall_chk.isChecked(),
            "waterfall_depth": self.waterfall_depth.value(),
        }


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Main window
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class MainWindow(QMainWindow):
    def __init__(self, num_channels=4, shared=None):
        super().__init__()
        self.num_channels = num_channels
        self.shared = shared or {}
        self._plot_queue = self.shared.get("plot_queue")
        self._raw_queue = self.shared.get("raw_queue")
        self._pfb_queue = self.shared.get("pfb_queue")
        self._stop_event = self.shared.get("stop_event")
        self._pfb_config_queue = self.shared.get("pfb_config_queue")
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
        self._wf_buffers = {}   # (ptype, key) -> 2-D ndarray  (depth, P)
        self._wf_images = {}   # (ptype, key) -> AxesImage
        self._waterfall = False
        self._wf_depth = 100
        self._active_plots = []
        self._freq_mhz = np.array([])
        self._paused = False

        self._build_ui()
        self._start_timer()
        # Defer the first rebuild until the window has its real geometry
        QTimer.singleShot(0, self._rebuild_plots)

    # ── layout ─────────────────────────────────────────────────
    def _build_ui(self):
        # sidebar
        self.panel = SettingsPanel()
        self.panel.device_settings_changed.connect(self._apply_device)
        self.panel.pfb_settings_changed.connect(self._apply_pfb)
        self.panel.plot_selection_changed.connect(self._rebuild_plots)

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
        self._raw_q_label = QLabel("raw: 0")
        self._pfb_q_label = QLabel("pfb: 0")
        for lbl in (self._raw_q_label, self._pfb_q_label):
            lbl.setStyleSheet("padding: 0 8px; color: #aaaaaa;")
            self.sbar.addPermanentWidget(lbl)
        self.sbar.showMessage("Ready — waiting for first frame …")

    # ── timer ──────────────────────────────────────────────────
    def _start_timer(self):
        self._timer = QTimer(self)
        self._timer.timeout.connect(self._update_plots)
        ms = int(self.panel.interval_spin.value() * 1000)
        self._timer.start(ms)
        self.panel.interval_spin.valueChanged.connect(
            lambda v: self._timer.setInterval(int(v * 1000))
        )

    # ── plot grid rebuild ──────────────────────────────────────
    def _rebuild_plots(self):
        sel = self.panel.get_plot_selection()
        self.canvas.fig.clear()
        self._axes.clear()
        self._lines.clear()
        self._wf_buffers.clear()
        self._wf_images.clear()
        self._active_plots.clear()

        self._waterfall = sel.get("waterfall", False)
        self._wf_depth = sel.get("waterfall_depth", 100)
        self._iq_component = sel.get("iq_component", "I + Q")

        # collect active plot descriptors
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

            use_wf = self._waterfall and ptype in ("pfb", "corr")

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

            elif ptype == "pfb" and not use_wf:
                lp, = ax.plot([], [], color="tab:green", alpha=0.85)
                self._lines[(ptype, key)] = (lp,)
                ax.set_title(f"PFB Ch {key}  (dB)", fontsize=9)
                ax.set_xlabel("Frequency (MHz)")
                ax.grid(True)

            elif ptype == "pfb" and use_wf:
                buf = np.full((self._wf_depth, self._P), np.nan)
                self._wf_buffers[(ptype, key)] = buf
                im = ax.imshow(
                    buf,
                    aspect="auto",
                    origin="lower",
                    extent=[f_lo, f_hi, 0, self._wf_depth],
                    cmap="viridis",
                    interpolation="nearest",
                )
                self._wf_images[(ptype, key)] = im
                ax.set_title(f"PFB Ch {key}  Waterfall (dB)", fontsize=9)
                ax.set_xlabel("Frequency (MHz)")
                ax.set_ylabel("Time (frames)")

            elif ptype == "corr" and not use_wf:
                a, b = int(key[0]), int(key[1])
                tag = f"Auto {a}" if a == b else f"Cross {a}×{b}"
                lc, = ax.plot([], [], color="tab:purple", alpha=0.85)
                self._lines[(ptype, key)] = (lc,)
                ax.set_title(f"{tag}  (dB)", fontsize=9)
                ax.set_xlabel("Frequency (MHz)")
                ax.grid(True)

            elif ptype == "corr" and use_wf:
                a, b = int(key[0]), int(key[1])
                tag = f"Auto {a}" if a == b else f"Cross {a}×{b}"
                buf = np.full((self._wf_depth, self._P), np.nan)
                self._wf_buffers[(ptype, key)] = buf
                im = ax.imshow(
                    buf,
                    aspect="auto",
                    origin="lower",
                    extent=[f_lo, f_hi, 0, self._wf_depth],
                    cmap="inferno",
                    interpolation="nearest",
                )
                self._wf_images[(ptype, key)] = im
                ax.set_title(f"{tag}  waterfall (dB)", fontsize=9)
                ax.set_xlabel("Frequency (MHz)")
                ax.set_ylabel("Time (frames)")

        self.canvas.fig.suptitle("FX Correlator", fontsize=11)
        self.canvas.fig.tight_layout(rect=[0, 0, 1, 0.96])
        self.canvas.draw_idle()

    # ── pause toggle ───────────────────────────────────────────
    def _toggle_pause(self, checked):
        self._paused = checked
        self._pause_btn.setText("▶  Resume" if checked else "⏸  Pause")
        self.sbar.showMessage("⏸  Display paused" if checked else "▶  Display resumed")

    # ── periodic data pull ─────────────────────────────────────
    def _update_plots(self):
        if self._plot_queue is None:
            return

        # update queue-size indicators
        try:
            rq = self._raw_queue.qsize() if self._raw_queue else 0
            pq = self._pfb_queue.qsize() if self._pfb_queue else 0
            self._raw_q_label.setText(f"raw: {rq}")
            self._pfb_q_label.setText(f"pfb: {pq}")
        except Exception:
            pass

        # Drain the mp queue, keep only the newest frame
        frame = None
        try:
            while True:
                frame = self._plot_queue.get_nowait()
        except Exception:       # queue.Empty or OSError
            pass

        if frame is None or self._paused:
            return

        is_dict = isinstance(frame, dict)
        raw = frame.get("raw", frame) if is_dict else frame
        pfb = frame.get("pfb") if is_dict else None
        corr = frame.get("correlations", {}) if is_dict else {}

        for (ptype, key), ax in self._axes.items():
            is_wf = (ptype, key) in self._wf_images

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

            # ── PFB ────────────────────────────────────────────
            elif ptype == "pfb" and pfb is not None:
                ch = key
                if ch >= pfb.shape[0]:
                    continue
                row = pfb[ch]                                    # already dB
                if is_wf:
                    buf = self._wf_buffers[(ptype, key)]
                    buf[:-1] = buf[1:]                           # roll up
                    buf[-1] = row if row.shape[0] == buf.shape[1] else np.interp(
                        np.linspace(0, 1, buf.shape[1]),
                        np.linspace(0, 1, row.shape[0]), row,
                    )
                    im = self._wf_images[(ptype, key)]
                    im.set_data(buf)
                    finite = buf[np.isfinite(buf)]
                    if finite.size:
                        im.set_clim(vmin=finite.min(), vmax=finite.max())
                else:
                    lines = self._lines.get((ptype, key))
                    if lines and row.shape[0] == self._freq_mhz.shape[0]:
                        lines[0].set_data(self._freq_mhz, row)
                        ax.relim()
                        ax.autoscale_view()

            # ── Correlations ───────────────────────────────────
            elif ptype == "corr" and corr:
                if key not in corr:
                    continue
                row = 10 * np.log10(np.abs(corr[key]) + 1e-12)
                if is_wf:
                    buf = self._wf_buffers[(ptype, key)]
                    buf[:-1] = buf[1:]
                    buf[-1] = row if row.shape[0] == buf.shape[1] else np.interp(
                        np.linspace(0, 1, buf.shape[1]),
                        np.linspace(0, 1, row.shape[0]), row,
                    )
                    im = self._wf_images[(ptype, key)]
                    im.set_data(buf)
                    finite = buf[np.isfinite(buf)]
                    if finite.size:
                        im.set_clim(vmin=finite.min(), vmax=finite.max())
                else:
                    lines = self._lines.get((ptype, key))
                    if lines and row.shape[0] == self._freq_mhz.shape[0]:
                        lines[0].set_data(self._freq_mhz, row)
                        ax.relim()
                        ax.autoscale_view()

        ts = time.strftime("%H:%M:%S")
        self.canvas.fig.suptitle(f"FX Correlator — {ts}", fontsize=11)
        self.canvas.draw_idle()

        self.sbar.showMessage(
            f"Last update: {ts}  |  PFB: {'ON' if self._pfb_enable else 'OFF'}  |  "
            f"Plots: {len(self._active_plots)}  |  "
            f"LO: {self._fs / 1e6:.3f} MSps"
        )

    # ── apply device settings ──────────────────────────────────
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

    # ── apply PFB settings ─────────────────────────────────────
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
            settings.FRAME_SIZE = new_p
            settings.BUFFER_SIZE = new_p * 100

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
            self._rebuild_plots()

            self.sbar.showMessage(
                f"✓  PFB {'enabled' if cfg['PFB_ENABLE'] else 'disabled'} — "
                f"P={new_p}  M={new_m}  window={new_win}"
            )
        except Exception as exc:
            QMessageBox.warning(self, "PFB Error", str(exc))
            self.sbar.showMessage(f"⚠  PFB error: {exc}")

    # ── handle resize so tight_layout stays correct ────────────
    def resizeEvent(self, event):
        super().resizeEvent(event)
        try:
            self.canvas.fig.tight_layout(rect=[0, 0, 1, 0.96])
            self.canvas.draw_idle()
        except Exception:
            pass

    # ── clean shutdown ─────────────────────────────────────────
    def closeEvent(self, event):
        self._timer.stop()
        if self._stop_event is not None:
            self._stop_event.set()
        event.accept()


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Dark Fusion palette
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Public entry point  (replaces run_plot_loop)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
def run_ui(num_channels=4, shared=None):
    """Launch the FX Correlator GUI.  Blocks until the window is closed."""
    app = QApplication.instance()
    if app is None:
        app = QApplication(sys.argv)

    app.setStyle("Fusion")
    _apply_dark_palette(app)

    win = MainWindow(num_channels=num_channels, shared=shared)
    win.show()
    return app.exec_()
