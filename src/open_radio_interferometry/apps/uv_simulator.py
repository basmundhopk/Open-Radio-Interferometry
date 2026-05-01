#!/usr/bin/env python3
"""
UV-plane coverage simulator for a given antenna array, source declination, and time window.

  - _apply_dark_palette(): apply dark theme palette to a QApplication
  - _utc_to_jd():          Julian date from a UTC datetime
  - _hour_angle_rad():     hour angle in radians from UTC + observatory longitude
  - compute_uv_track():    UV track (in wavelengths) for a baseline over time
  - SimWindow:             Qt window with controls and UV-plane plot
  - main():                application entry point
"""

import sys
import numpy as np
import pyqtgraph as pg

pg.setConfigOptions(
    antialias=True,
    background="#1e1e1e",
    foreground="#cccccc",
    useOpenGL=False,
)

from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QFormLayout, QGroupBox, QDoubleSpinBox, QSpinBox, QPushButton,
    QLabel, QScrollArea, QDockWidget, QSizePolicy, QSlider,
)
from PyQt5.QtCore import Qt, QTimer, QDateTime
from PyQt5.QtGui import QPalette, QColor
from datetime import datetime, timezone, timedelta

from open_radio_interferometry import settings

# 10 distinguishable colors (tab10-equivalent)
_TAB10 = [
    (31, 119, 180),  (255, 127, 14), (44, 160, 44),  (214, 39, 40),
    (148, 103, 189), (140, 86, 75),  (227, 119, 194), (127, 127, 127),
    (188, 189, 34),  (23, 190, 207),
]

def _apply_dark_palette(app):
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
    p.setColor(QPalette.Highlight,       QColor(42, 130, 218))
    p.setColor(QPalette.HighlightedText, QColor(35, 35, 35))
    app.setPalette(p)

# Sidereal-time helpers
def _utc_to_jd(dt):
    y, m = dt.year, dt.month
    if m <= 2:
        y -= 1; m += 12
    A = int(y / 100)
    B = 2 - A + int(A / 4)
    day_frac = (dt.hour + dt.minute / 60.0 + dt.second / 3600.0) / 24.0
    return int(365.25 * (y + 4716)) + int(30.6001 * (m + 1)) + dt.day + day_frac + B - 1524.5


def _hour_angle_rad(dt_utc, lon_deg, ra_deg=0.0):
    jd = _utc_to_jd(dt_utc)
    T = (jd - 2451545.0) / 36525.0
    gmst = (280.46061837
            + 360.98564736629 * (jd - 2451545.0)
            + 0.000387933 * T**2
            - T**3 / 38710000.0) % 360.0
    lst = (gmst + lon_deg) % 360.0
    return np.radians(lst - ra_deg)


def compute_uv_track(bl_enu, times, lat_deg, lon_deg, dec_deg, freq_hz, ra_deg=0.0):
    c = 299792458.0
    lam = c / freq_hz
    dE, dN, dU = bl_enu
    lat, dec = np.radians(lat_deg), np.radians(dec_deg)
    sin_l, cos_l = np.sin(lat), np.cos(lat)
    sin_d, cos_d = np.sin(dec), np.cos(dec)
    u = np.empty(len(times))
    v = np.empty(len(times))
    for k, t in enumerate(times):
        H = _hour_angle_rad(t, lon_deg, ra_deg)
        sH, cH = np.sin(H), np.cos(H)
        u[k] = (dE * cH - dN * sin_l * sH) / lam
        v[k] = (dE * sin_d * sH + dN * (sin_l * sin_d * cH + cos_l * cos_d)) / lam
    return u, v


def _hour_angles_rad(jds, lon_deg, ra_deg=0.0):
    """Vectorized GMST -> hour angle (radians) for an array of Julian dates."""
    jds = np.asarray(jds, dtype=np.float64)
    T = (jds - 2451545.0) / 36525.0
    gmst = (280.46061837
            + 360.98564736629 * (jds - 2451545.0)
            + 0.000387933 * T**2
            - T**3 / 38710000.0) % 360.0
    lst = (gmst + lon_deg) % 360.0
    return np.radians(lst - ra_deg)


def compute_uv_tracks(baselines, jds, lat_deg, lon_deg, dec_deg, freq_hz, ra_deg=0.0):
    """Vectorized UV tracks for many baselines at many times.

    baselines: array (B, 3) of ENU vectors (metres)
    jds:       array (T,)   of Julian dates
    Returns:   u, v of shape (B, T) in wavelengths.
    """
    c = 299792458.0
    lam = c / freq_hz
    bl = np.asarray(baselines, dtype=np.float64)        # (B, 3)
    dE = bl[:, 0:1]                                     # (B, 1)
    dN = bl[:, 1:2]
    lat = np.radians(lat_deg)
    dec = np.radians(dec_deg)
    sin_l, cos_l = np.sin(lat), np.cos(lat)
    sin_d, cos_d = np.sin(dec), np.cos(dec)
    H = _hour_angles_rad(jds, lon_deg, ra_deg)          # (T,)
    sH = np.sin(H)[None, :]                             # (1, T)
    cH = np.cos(H)[None, :]
    u = (dE * cH - dN * sin_l * sH) / lam               # (B, T)
    v = (dE * sin_d * sH + dN * (sin_l * sin_d * cH + cos_l * cos_d)) / lam
    return u, v


class _LabeledSlider(QWidget):
    """Horizontal slider with a value label. Floating-point values are
    represented as integers internally (scale = 1/step).
    Connect to .valueChanged(float) signal-style via .slider.valueChanged."""

    def __init__(self, vmin, vmax, value, step=0.1, suffix="", parent=None):
        super().__init__(parent)
        self._step = step
        self._suffix = suffix
        self._scale = round(1.0 / step) if step < 1 else 1

        lay = QHBoxLayout(self)
        lay.setContentsMargins(0, 0, 0, 0)
        lay.setSpacing(6)

        self.slider = QSlider(Qt.Horizontal)
        self.slider.setRange(int(round(vmin * self._scale)), int(round(vmax * self._scale)))
        self.slider.setValue(int(round(value * self._scale)))
        self.slider.valueChanged.connect(self._on_change)

        self.label = QLabel()
        self.label.setMinimumWidth(70)
        self.label.setStyleSheet("color: #cccccc; font-size: 11px;")
        self._update_label()

        lay.addWidget(self.slider, stretch=1)
        lay.addWidget(self.label)

    def _on_change(self, _):
        self._update_label()

    def _update_label(self):
        v = self.value()
        if self._step >= 1:
            self.label.setText(f"{int(v)}{self._suffix}")
        else:
            decimals = max(0, -int(round(np.log10(self._step))))
            self.label.setText(f"{v:.{decimals}f}{self._suffix}")

    def value(self):
        return self.slider.value() / self._scale

    def setValue(self, v):
        self.slider.setValue(int(round(v * self._scale)))


class SimWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("UV Track Simulator")
        self.setMinimumSize(1100, 750)
        self.resize(1300, 850)
        self._build_ui()
        self._recalculate()

    def _build_ui(self):
        # ── sidebar ───────────────────────────────────────────
        panel = QWidget()
        root = QVBoxLayout(panel)
        root.setContentsMargins(6, 6, 6, 6)

        # Observatory
        obs = QGroupBox("Observatory")
        of = QFormLayout()
        self.lat_spin = QDoubleSpinBox(); self.lat_spin.setRange(-90, 90)
        self.lat_spin.setDecimals(4); self.lat_spin.setSuffix("°")
        self.lat_spin.setValue(settings.OBSERVATION_LATITUDE_DEG)
        of.addRow("Latitude:", self.lat_spin)
        self.lon_spin = QDoubleSpinBox(); self.lon_spin.setRange(-180, 180)
        self.lon_spin.setDecimals(4); self.lon_spin.setSuffix("°")
        self.lon_spin.setValue(settings.OBSERVATION_LONGITUDE_DEG)
        of.addRow("Longitude:", self.lon_spin)
        obs.setLayout(of)
        root.addWidget(obs)

        # Source
        src = QGroupBox("Source")
        sf = QFormLayout()
        self.dec_spin = QDoubleSpinBox(); self.dec_spin.setRange(-90, 90)
        self.dec_spin.setDecimals(4); self.dec_spin.setSuffix("°")
        self.dec_spin.setValue(settings.OBSERVATION_DECLINATION_DEG)
        sf.addRow("Declination:", self.dec_spin)
        self.ra_spin = QDoubleSpinBox(); self.ra_spin.setRange(0, 360)
        self.ra_spin.setDecimals(4); self.ra_spin.setSuffix("°")
        self.ra_spin.setValue(0.0)
        sf.addRow("Right Ascension:", self.ra_spin)
        self.freq_spin = QDoubleSpinBox(); self.freq_spin.setRange(1, 100000)
        self.freq_spin.setDecimals(3); self.freq_spin.setSuffix("  MHz")
        self.freq_spin.setValue(settings.rx_lo / 1e6)
        sf.addRow("Frequency:", self.freq_spin)
        src.setLayout(sf)
        root.addWidget(src)

        # Time
        tg = QGroupBox("Observation Window")
        tf = QFormLayout()
        self.start_hour  = _LabeledSlider(-48.0, 48.0, 0.0, step=0.25, suffix=" h")
        tf.addRow("Start offset:", self.start_hour)
        self.duration_spin = _LabeledSlider(0.1, 24.0, 6.0, step=0.1, suffix=" h")
        dur_row = QWidget(); _dl = QHBoxLayout(dur_row)
        _dl.setContentsMargins(0, 0, 0, 0); _dl.setSpacing(4)
        _dl.addWidget(self.duration_spin, stretch=1)
        self.duration_sweep_btn = QPushButton("▶")
        self.duration_sweep_btn.setCheckable(True)
        self.duration_sweep_btn.setFixedWidth(28)
        self.duration_sweep_btn.setToolTip(
            "Sweep duration 1→ 24→ 1 h continuously")
        self.duration_sweep_btn.toggled.connect(self._toggle_duration_sweep)
        _dl.addWidget(self.duration_sweep_btn)
        tf.addRow("Duration:", dur_row)
        self.steps_spin    = QSpinBox(); self.steps_spin.setRange(50, 5000)
        self.steps_spin.setSingleStep(10); self.steps_spin.setValue(500)
        tf.addRow("Time steps:",   self.steps_spin)
        tg.setLayout(tf)
        root.addWidget(tg)

        # Antenna positions
        ag = QGroupBox("Antenna Positions (ENU, metres)")
        af = QFormLayout()
        self.ant_east = []
        self.ant_north = []
        for i in range(4):
            pos = settings.ANTENNA_POSITIONS_ENU[i] if i < len(settings.ANTENNA_POSITIONS_ENU) else (0, 0, 0)
            e = QDoubleSpinBox(); e.setRange(-1000, 1000); e.setDecimals(2); e.setSuffix(" m")
            e.setValue(pos[0])
            af.addRow(f"Ant {i} East:", e)
            self.ant_east.append(e)
            n = QDoubleSpinBox(); n.setRange(-1000, 1000); n.setDecimals(2); n.setSuffix(" m")
            n.setValue(pos[1])
            af.addRow(f"Ant {i} North:", n)
            self.ant_north.append(n)
        ag.setLayout(af)
        root.addWidget(ag)

        self.reset_btn = QPushButton("⟲  Reset to Defaults")
        self.reset_btn.setStyleSheet("padding: 8px; font-weight: bold;")
        self.reset_btn.clicked.connect(self._reset_defaults)
        root.addWidget(self.reset_btn)

        self.summary_label = QLabel("")
        self.summary_label.setWordWrap(True)
        self.summary_label.setStyleSheet("color: #aaaaaa; font-size: 10px; padding: 4px;")
        root.addWidget(self.summary_label)

        root.addStretch()

        # ── auto-recalc wiring (debounced) ─────────────────────────
        # Throttle: redraw at a steady ~30 fps during continuous input.
        # A pure debounce starves under fast slider/marker motion because
        # every new event resets the timer before it can fire.
        self._min_interval_ms = 33
        self._last_recalc_ms = 0
        self._recalc_pending = False
        self._recalc_timer = QTimer(self)
        self._recalc_timer.setSingleShot(True)
        self._recalc_timer.timeout.connect(self._run_pending_recalc)

        for w in (self.lat_spin, self.lon_spin, self.dec_spin,
                  self.ra_spin, self.freq_spin, self.steps_spin):
            w.valueChanged.connect(self._schedule_recalc)
        for w in (self.start_hour, self.duration_spin):
            w.slider.valueChanged.connect(self._schedule_recalc)
        for w in self.ant_east + self.ant_north:
            w.valueChanged.connect(self._schedule_recalc)

        scroll = QScrollArea()
        scroll.setWidget(panel)
        scroll.setWidgetResizable(True)
        scroll.setHorizontalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
        scroll.setMinimumWidth(280)
        scroll.setMaximumWidth(350)

        dock = QDockWidget("Parameters", self)
        dock.setWidget(scroll)
        dock.setFeatures(QDockWidget.DockWidgetMovable | QDockWidget.DockWidgetFloatable)
        self.addDockWidget(Qt.LeftDockWidgetArea, dock)

        # ── central plot ──────────────────────────────────────
        central = QWidget()
        cl = QVBoxLayout(central)
        cl.setContentsMargins(0, 0, 0, 0)
        self.gview = pg.GraphicsLayoutWidget(parent=central)
        self.gview.setBackground("#1e1e1e")
        self.gview.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        self.plot = self.gview.addPlot(row=0, col=0)
        self.plot.showGrid(x=True, y=True, alpha=0.3)
        self.plot.setAspectLocked(True)
        self.plot.setLabel("bottom", "u  (wavelengths)", color="#cccccc")
        self.plot.setLabel("left",   "v  (wavelengths)", color="#cccccc")
        self._legend = self.plot.addLegend(offset=(-10, 10), labelTextColor="#cccccc")

        # Antenna layout plot (draggable markers)
        self.ant_plot = self.gview.addPlot(row=0, col=1)
        self.ant_plot.showGrid(x=True, y=True, alpha=0.3)
        self.ant_plot.setAspectLocked(True)
        self.ant_plot.setLabel("bottom", "East  (m)", color="#cccccc")
        self.ant_plot.setLabel("left",   "North (m)", color="#cccccc")
        self.ant_plot.setTitle("Antenna Layout", color="#cccccc", size="10pt")
        # UV plot gets ~2x the horizontal space of the antenna plot
        self.gview.ci.layout.setColumnStretchFactor(0, 2)
        self.gview.ci.layout.setColumnStretchFactor(1, 1)

        # Build draggable target markers + text labels for each antenna
        self._ant_targets = []
        self._ant_labels = []
        self._suppress_target_sync = False
        for i in range(4):
            r, g, b = _TAB10[i % len(_TAB10)]
            tgt = pg.TargetItem(
                pos=(self.ant_east[i].value(), self.ant_north[i].value()),
                size=14,
                movable=True,
                pen=pg.mkPen(r, g, b, width=2),
                brush=pg.mkBrush(r, g, b, 160),
                hoverPen=pg.mkPen(255, 255, 255, width=2),
                hoverBrush=pg.mkBrush(r, g, b, 220),
            )
            tgt.sigPositionChanged.connect(lambda t, idx=i: self._on_target_moved(idx, t))
            self.ant_plot.addItem(tgt)

            txt = pg.TextItem(text=f" Ant {i}", color=(r, g, b), anchor=(0, 0.5))
            txt.setPos(self.ant_east[i].value(), self.ant_north[i].value())
            self.ant_plot.addItem(txt)

            self._ant_targets.append(tgt)
            self._ant_labels.append(txt)

        # Keep targets in sync when spinboxes are edited directly
        for i in range(4):
            self.ant_east[i].valueChanged.connect(lambda _v, idx=i: self._sync_target_from_spin(idx))
            self.ant_north[i].valueChanged.connect(lambda _v, idx=i: self._sync_target_from_spin(idx))

        self._fit_antenna_view()

        cl.addWidget(self.gview)
        self.setCentralWidget(central)

    def _on_target_moved(self, idx, target):
        """User dragged an antenna marker — push the new position into the
        spinboxes (which schedules a recalc via the existing wiring)."""
        if self._suppress_target_sync:
            return
        pos = target.pos()
        e, n = float(pos.x()), float(pos.y())
        # Block spinbox signals so we only schedule one recalc per move
        self._suppress_target_sync = True
        try:
            self.ant_east[idx].blockSignals(True)
            self.ant_north[idx].blockSignals(True)
            self.ant_east[idx].setValue(e)
            self.ant_north[idx].setValue(n)
            self.ant_east[idx].blockSignals(False)
            self.ant_north[idx].blockSignals(False)
            self._ant_labels[idx].setPos(e, n)
        finally:
            self._suppress_target_sync = False
        self._schedule_recalc()

    def _sync_target_from_spin(self, idx):
        """Spinbox edited externally — move the corresponding marker."""
        if self._suppress_target_sync:
            return
        e = self.ant_east[idx].value()
        n = self.ant_north[idx].value()
        self._suppress_target_sync = True
        try:
            self._ant_targets[idx].setPos(e, n)
            self._ant_labels[idx].setPos(e, n)
        finally:
            self._suppress_target_sync = False

    def _fit_antenna_view(self, pad_frac=0.25, min_half=5.0):
        es = [w.value() for w in self.ant_east]
        ns = [w.value() for w in self.ant_north]
        cx = (max(es) + min(es)) / 2.0
        cy = (max(ns) + min(ns)) / 2.0
        half = max(max(es) - min(es), max(ns) - min(ns)) / 2.0
        half = max(half * (1.0 + pad_frac), min_half)
        self.ant_plot.setRange(
            xRange=(cx - half, cx + half),
            yRange=(cy - half, cy + half),
            padding=0,
        )

    def _schedule_recalc(self, *_):
        """Throttle recalcs so continuous input still produces frames."""
        if self._recalc_pending:
            return
        now_ms = QDateTime.currentMSecsSinceEpoch()
        elapsed = now_ms - self._last_recalc_ms
        if elapsed >= self._min_interval_ms:
            self._recalculate()
        else:
            self._recalc_pending = True
            self._recalc_timer.start(self._min_interval_ms - int(elapsed))

    def _run_pending_recalc(self):
        self._recalc_pending = False
        self._recalculate()

    # Duration sweep ---------------------------------------------------
    _SWEEP_MIN_H = 1.0
    _SWEEP_MAX_H = 24.0
    _SWEEP_STEP_H = 0.1   # change per tick
    _SWEEP_INTERVAL_MS = 50

    def _toggle_duration_sweep(self, on):
        if on:
            self.duration_sweep_btn.setText("■")
            if not hasattr(self, "_sweep_timer"):
                self._sweep_timer = QTimer(self)
                self._sweep_timer.timeout.connect(self._sweep_tick)
            # If we're already at the top, restart from the bottom so the
            # button always produces a visible sweep.
            if self.duration_spin.value() >= self._SWEEP_MAX_H:
                self.duration_spin.setValue(self._SWEEP_MIN_H)
            self._sweep_timer.start(self._SWEEP_INTERVAL_MS)
        else:
            self.duration_sweep_btn.setText("▶")
            if hasattr(self, "_sweep_timer"):
                self._sweep_timer.stop()

    def _sweep_tick(self):
        v = self.duration_spin.value() + self._SWEEP_STEP_H
        if v >= self._SWEEP_MAX_H:
            self.duration_spin.setValue(self._SWEEP_MAX_H)
            # Stop the sweep when we hit the cap.
            self.duration_sweep_btn.setChecked(False)
            return
        self.duration_spin.setValue(v)  # triggers _schedule_recalc via slider

    def _reset_defaults(self):
        """Restore every control to the value in settings._DEFAULTS."""
        d = settings._DEFAULTS
        self.lat_spin.setValue(d["OBSERVATION_LATITUDE_DEG"])
        self.lon_spin.setValue(d["OBSERVATION_LONGITUDE_DEG"])
        self.dec_spin.setValue(d["OBSERVATION_DECLINATION_DEG"])
        self.ra_spin.setValue(d.get("SOURCE_RA_DEG", 0.0))
        self.freq_spin.setValue(d["rx_lo"] / 1e6)
        self.start_hour.setValue(0.0)
        self.duration_spin.setValue(6.0)
        self.steps_spin.setValue(500)
        positions = d["ANTENNA_POSITIONS_ENU"]
        for i in range(4):
            pos = positions[i] if i < len(positions) else (0.0, 0.0, 0.0)
            self.ant_east[i].setValue(pos[0])
            self.ant_north[i].setValue(pos[1])
        self._fit_antenna_view()

    def _recalculate(self):
        self._last_recalc_ms = QDateTime.currentMSecsSinceEpoch()
        lat  = self.lat_spin.value()
        lon  = self.lon_spin.value()
        dec  = self.dec_spin.value()
        ra   = self.ra_spin.value()
        freq = self.freq_spin.value() * 1e6
        steps = self.steps_spin.value()
        steps = max(2, int(steps))

        now = datetime.now(timezone.utc)
        t_start = now + timedelta(hours=self.start_hour.value())
        t_stop  = t_start + timedelta(hours=self.duration_spin.value())
        dt_total = (t_stop - t_start).total_seconds()
        # Linearly spaced JDs (no per-step datetime objects needed)
        jd_start = _utc_to_jd(t_start)
        jds = jd_start + np.linspace(0.0, dt_total / 86400.0, steps)

        positions = np.array([
            (self.ant_east[i].value(), self.ant_north[i].value(), 0.0)
            for i in range(4)
        ])
        chan_to_ant = settings.CHANNEL_TO_ANTENNA

        baselines, labels = [], []
        for i in range(4):
            for j in range(i + 1, 4):
                ai, aj = chan_to_ant[i], chan_to_ant[j]
                if ai == aj:
                    continue
                baselines.append(positions[aj] - positions[ai])
                labels.append(f"{i}×{j}  (Ant {ai}–{aj})")

        # ── draw ──────────────────────────────────────────────
        self.plot.clear()
        try:
            self._legend.scene().removeItem(self._legend)
        except Exception:
            pass
        self._legend = self.plot.addLegend(offset=(-10, 10), labelTextColor="#cccccc")

        if baselines:
            uu, vv = compute_uv_tracks(
                np.asarray(baselines), jds, lat, lon, dec, freq, ra_deg=ra
            )
        else:
            uu = vv = np.empty((0, steps))

        for idx, lbl in enumerate(labels):
            u, v = uu[idx], vv[idx]
            r, g, b = _TAB10[idx % len(_TAB10)]
            self.plot.plot(
                u, v, pen=None, symbol="o", symbolSize=2,
                symbolBrush=pg.mkBrush(r, g, b, 180),
                symbolPen=None, name=lbl,
            )
            self.plot.plot(
                -u, -v, pen=None, symbol="o", symbolSize=2,
                symbolBrush=pg.mkBrush(r, g, b, 90),
                symbolPen=None,
            )

        self.plot.setTitle(
            f"UV Tracks — {t_start.strftime('%Y-%m-%d %H:%M')} → "
            f"{t_stop.strftime('%H:%M')} UTC  |  "
            f"{self.duration_spin.value():.1f}h  |  "
            f"{freq/1e6:.1f} MHz  |  Dec {dec:.1f}°",
            color="#cccccc", size="10pt",
        )

        # ── summary ───────────────────────────────────────────
        c_val = 299792458.0
        lam = c_val / freq
        lines = [f"<b>{len(baselines)}</b> baselines  |  λ = {lam:.4f} m"]
        for bl, lbl in zip(baselines, labels):
            length = np.linalg.norm(bl)
            lines.append(f"  {lbl}  —  {length:.2f} m  =  {length/lam:.1f} λ")
        self.summary_label.setText("<br>".join(lines))


def main():
    app = QApplication.instance() or QApplication(sys.argv)
    app.setStyle("Fusion")
    _apply_dark_palette(app)
    win = SimWindow()
    win.show()
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()