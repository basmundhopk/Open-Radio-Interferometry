#!/usr/bin/env python3
"""
Simulator to see data coverage in the UV plane for a given set of antenna positions, source declination, and observation time window

"""

import sys
import numpy as np
import matplotlib
matplotlib.use("Qt5Agg")

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg, NavigationToolbar2QT
from matplotlib.figure import Figure

from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QFormLayout, QGroupBox, QDoubleSpinBox, QSpinBox, QPushButton,
    QLabel, QScrollArea, QDockWidget, QSizePolicy,
)
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QPalette, QColor
from datetime import datetime, timezone, timedelta

import settings

# ── Dark palette ──────────────────────────────────────────────
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

_MPL_DARK = {
    "figure.facecolor": "#2b2b2b",
    "axes.facecolor":   "#1e1e1e",
    "axes.edgecolor":   "#555555",
    "axes.labelcolor":  "#cccccc",
    "text.color":       "#cccccc",
    "xtick.color":      "#aaaaaa",
    "ytick.color":      "#aaaaaa",
    "grid.color":       "#444444",
    "grid.alpha":       0.5,
    "legend.facecolor": "#2b2b2b",
    "legend.edgecolor": "#555555",
    "legend.fontsize":  8,
}
matplotlib.rcParams.update(_MPL_DARK)


# ── Sidereal-time helpers ─────────────────────────────────────
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


# ── GUI ───────────────────────────────────────────────────────
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
        self.start_hour = QDoubleSpinBox(); self.start_hour.setRange(-48, 48)
        self.start_hour.setDecimals(2); self.start_hour.setSuffix("  h from now")
        self.start_hour.setValue(0.0)
        tf.addRow("Start offset:", self.start_hour)
        self.duration_spin = QDoubleSpinBox(); self.duration_spin.setRange(0.1, 24)
        self.duration_spin.setDecimals(2); self.duration_spin.setSuffix("  hours")
        self.duration_spin.setValue(6.0)
        tf.addRow("Duration:", self.duration_spin)
        self.steps_spin = QSpinBox(); self.steps_spin.setRange(50, 5000)
        self.steps_spin.setValue(500)
        tf.addRow("Time steps:", self.steps_spin)
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

        # Recalculate button
        self.recalc_btn = QPushButton("⟳  Recalculate")
        self.recalc_btn.setStyleSheet("padding: 8px; font-weight: bold;")
        self.recalc_btn.clicked.connect(self._recalculate)
        root.addWidget(self.recalc_btn)

        self.summary_label = QLabel("")
        self.summary_label.setWordWrap(True)
        self.summary_label.setStyleSheet("color: #aaaaaa; font-size: 10px; padding: 4px;")
        root.addWidget(self.summary_label)

        root.addStretch()

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
        self.fig = Figure(dpi=100)
        self.canvas = FigureCanvasQTAgg(self.fig)
        self.canvas.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        self.toolbar = NavigationToolbar2QT(self.canvas, central)
        cl.addWidget(self.toolbar)
        cl.addWidget(self.canvas)
        self.setCentralWidget(central)

    def _recalculate(self):
        lat  = self.lat_spin.value()
        lon  = self.lon_spin.value()
        dec  = self.dec_spin.value()
        ra   = self.ra_spin.value()
        freq = self.freq_spin.value() * 1e6
        steps = self.steps_spin.value()

        now = datetime.now(timezone.utc)
        t_start = now + timedelta(hours=self.start_hour.value())
        t_stop  = t_start + timedelta(hours=self.duration_spin.value())
        dt_total = (t_stop - t_start).total_seconds()
        times = [t_start + timedelta(seconds=dt_total * i / (steps - 1)) for i in range(steps)]

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
        self.fig.clear()
        ax = self.fig.add_subplot(111)
        colours = matplotlib.colormaps["tab10"](np.linspace(0, 1, max(len(baselines), 1)))

        for idx, (bl, lbl) in enumerate(zip(baselines, labels)):
            u, v = compute_uv_track(bl, times, lat, lon, dec, freq, ra_deg=ra)
            col = colours[idx]
            ax.plot(u, v, ".", markersize=1.5, color=col, alpha=0.7, label=lbl)
            ax.plot(-u, -v, ".", markersize=1.5, color=col, alpha=0.35)

        ax.set_xlabel("u  (wavelengths)")
        ax.set_ylabel("v  (wavelengths)")
        ax.set_title(
            f"UV Tracks — {t_start.strftime('%Y-%m-%d %H:%M')} → "
            f"{t_stop.strftime('%H:%M')} UTC  |  "
            f"{self.duration_spin.value():.1f}h  |  "
            f"{freq/1e6:.1f} MHz  |  Dec {dec:.1f}°",
            fontsize=10,
        )
        ax.set_aspect("equal")
        ax.grid(True, alpha=0.3)
        if baselines:
            ax.legend(loc="upper right", fontsize=8)

        self.fig.tight_layout()
        self.canvas.draw_idle()

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