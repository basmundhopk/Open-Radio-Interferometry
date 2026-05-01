#!/usr/bin/env python3
"""
Standalone UV-plane viewer for FX_Correlator FITS files.

Opens a FITS file produced by the FX_Correlator main app (or any compatible
file with a UV_DATA BinTable containing U, V, AMP, PHASE columns) and shows
the UV-plane scatter exactly the same way the main app does:

  - Left panel : UV Plane — Amplitude   (log10(|V|), inferno colormap)
  - Right panel: UV Plane — Phase       (rad,        twilight  colormap)

Both panels share the same axes, are aspect-locked, labelled in wavelengths,
and use the dark pyqtgraph theme used by the main UI.

Usage:
    python3 uv_app.py [fits_file]

If no file is given, a file picker is shown.
"""

import argparse
import os
import sys

import numpy as np
import pyqtgraph as pg

pg.setConfigOptions(
    antialias=True,
    background="#1e1e1e",
    foreground="#cccccc",
    imageAxisOrder="row-major",
    useOpenGL=False,
)

from PyQt5.QtGui import QColor, QPalette
from PyQt5.QtWidgets import (
    QApplication,
    QCheckBox,
    QComboBox,
    QFileDialog,
    QHBoxLayout,
    QLabel,
    QMainWindow,
    QMessageBox,
    QStatusBar,
    QVBoxLayout,
    QWidget,
)

# ── style constants (matches ui.py) ─────────────────────────────────────────
_TITLE_STYLE = {"color": "#dddddd", "size": "10pt"}
_LABEL_STYLE = {"color": "#cccccc", "font-size": "9pt"}

# Sequential / scientific colormaps (matches ui.py:_CMAP_CHOICES)
_CMAP_CHOICES = [
    "inferno", "magma", "plasma", "viridis", "cividis", "turbo",
    "jet", "hot", "cubehelix", "gray", "bone", "afmhot",
]

# Dirty-image grid sizes (matches ui.py IFFT resolution combo)
_GRID_CHOICES = [64, 128, 256, 512, 1024, 2048]


def _get_cmap(name):
    """pyqtgraph colormap helper, mirrors ui.py."""
    try:
        return pg.colormap.get(name, source="matplotlib")
    except Exception:
        try:
            return pg.colormap.get(name)
        except Exception:
            return pg.colormap.get("viridis")


# ── dark palette (matches the main app / clean_app) ─────────────────────────
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
    app.setStyleSheet("""
        QGroupBox { border: 1px solid #555; border-radius: 4px;
                    margin-top: 8px; padding-top: 8px; }
        QGroupBox::title { subcontrol-origin: margin; left: 8px; padding: 0 4px; }
    """)


# ── FITS loader (same contract as clean_app._load_uv_from_fits) ─────────────
def _load_uv_from_fits(path):
    try:
        from astropy.io import fits
    except ImportError:
        raise RuntimeError("astropy is required — install with  pip install astropy")

    with fits.open(path) as hdul:
        uv_hdu = None
        for h in hdul:
            if h.name.upper() == "UV_DATA":
                uv_hdu = h
                break
        if uv_hdu is None:
            raise RuntimeError(
                f"No 'UV_DATA' HDU in {os.path.basename(path)}.\n"
                "Expected a FITS file written by FX_Correlator "
                "(UV export or Dirty-Image export).")

        data = uv_hdu.data
        try:
            u     = np.asarray(data["U"],     dtype=np.float64)
            v     = np.asarray(data["V"],     dtype=np.float64)
            amp   = np.asarray(data["AMP"],   dtype=np.float64)
            phase = np.asarray(data["PHASE"], dtype=np.float64)
        except Exception as e:
            raise RuntimeError(f"UV_DATA HDU missing expected columns: {e}")

        if u.size == 0:
            raise RuntimeError("UV_DATA HDU is empty.")

        meta = {}
        for k in ("DATE-OBS", "FREQ", "INTCOUNT", "N_UV_PTS",
                  "OBS_LAT", "OBS_LON", "OBS_DEC", "TELESCOP", "OBJECT",
                  "BANDWDTH", "SAMPRATE"):
            if k in hdul[0].header:
                meta[k] = hdul[0].header[k]

    return {"u": u, "v": v, "amp": amp, "phase": phase, "meta": meta}


# cap on plotted points — building millions of QBrush objects freezes Qt.
# The main app receives pre-downsampled data from the correlator process; we
# do the equivalent random subsample here.
_MAX_UV_POINTS = 60_000


def _downsample(u, v, amp, phase, max_points=_MAX_UV_POINTS):
    n = u.size
    if n <= max_points:
        return u, v, amp, phase, n
    rng = np.random.default_rng(0)  # deterministic
    idx = rng.choice(n, size=max_points, replace=False)
    idx.sort()
    return u[idx], v[idx], amp[idx], phase[idx], n


# ── UV scatter setter (mirrors ui.py:_update_uv_scatter_item) ───────────────
def _populate_uv_scatter(sc, plot, u, v, amp, phase, is_phase, cmap_name=None,
                          clip_pct=2.0):
    """
    Render UV scatter. For amplitude, the data spans many decades, so a
    handful of outliers can compress the rest of the points into a single
    color bin. We:
      1. take log10(|V|),
      2. clip to the [clip_pct, 100-clip_pct] percentile range,
    so the colormap stretches over the bulk of the distribution rather than
    the full min..max range. clip_pct=0 disables clipping (true min..max).
    """
    if not amp.size:
        return
    if is_phase:
        c_data = phase
        cmin = float(c_data.min())
        cmax = float(c_data.max())
    else:
        c_data = np.log10(amp + 1e-12)
        if clip_pct > 0:
            cmin = float(np.percentile(c_data, clip_pct))
            cmax = float(np.percentile(c_data, 100.0 - clip_pct))
        else:
            cmin = float(c_data.min())
            cmax = float(c_data.max())
    rng = cmax - cmin if cmax > cmin else 1.0
    norm = np.clip((c_data - cmin) / rng, 0.0, 1.0)
    if cmap_name is None:
        cmap_name = "twilight" if is_phase else "inferno"
    try:
        cmap = _get_cmap(cmap_name)
        colors = cmap.map(norm.astype(np.float32), mode="byte")  # (N, 4) uint8
    except Exception:
        g = (norm * 255).astype(np.uint8)
        colors = np.stack([g, g, g, np.full_like(g, 200)], axis=-1)
    brushes = [pg.mkBrush(int(c[0]), int(c[1]), int(c[2]), int(c[3]))
               for c in colors]
    sc.setData(x=u, y=v, brush=brushes, pen=None, size=4)

    u_min, u_max = float(u.min()), float(u.max())
    v_min, v_max = float(v.min()), float(v.max())
    span_u = max(u_max - u_min, 1.0)
    span_v = max(v_max - v_min, 1.0)
    margin_u = max(1.0, 0.05 * span_u)
    margin_v = max(1.0, 0.05 * span_v)
    rect = pg.QtCore.QRectF(
        u_min - margin_u,
        v_min - margin_v,
        (u_max - u_min) + 2 * margin_u,
        (v_max - v_min) + 2 * margin_v,
    )
    plot.getViewBox().setRange(rect=rect, padding=0)


# ── dirty image (mirrors correlator._save_dirty_fits gridding) ──────────────
def _compute_dirty(u, v, amp, phase, N):
    """Grid the visibilities and return (dirty_abs, lm_extent) for an N×N
    image. Uses the exact same formulae as the live correlator process."""
    if u.size == 0:
        return np.zeros((N, N), dtype=np.float32), 1.0
    uv_max = max(np.abs(u).max(), np.abs(v).max(), 1.0) * 1.05
    ui = np.floor((u / uv_max + 1.0) * 0.5 * N).astype(int)
    vi = np.floor((v / uv_max + 1.0) * 0.5 * N).astype(int)
    np.clip(ui, 0, N - 1, out=ui)
    np.clip(vi, 0, N - 1, out=vi)

    vis  = amp * np.exp(1j * phase)
    grid = np.zeros((N, N), dtype=np.complex128)
    wt   = np.zeros((N, N), dtype=np.float64)
    np.add.at(grid, (vi, ui), vis)
    np.add.at(wt,   (vi, ui), 1.0)
    m = wt > 0
    grid[m] /= wt[m]

    dirty = np.fft.ifftshift(np.fft.ifft2(np.fft.fftshift(grid))).real
    dirty_abs = np.abs(dirty).astype(np.float32)
    # lm extent in direction-cosine units: image spans [-lm_extent, +lm_extent]
    lm_extent = 0.5 * N / (2.0 * uv_max) * (2.0 / N) * (N / 2.0)
    # Equivalent simpler form:  lm_extent = N/2 * (1/(2*uv_max))
    lm_extent = (N / 2.0) * (1.0 / (2.0 * uv_max))
    return dirty_abs, float(lm_extent)


# ── main window ─────────────────────────────────────────────────────────────
class UVWindow(QMainWindow):
    def __init__(self, fits_path, snap):
        super().__init__()
        self.setWindowTitle(f"UV Plane — {os.path.basename(fits_path)}")
        self.resize(1500, 720)

        # full-resolution data (used for the dirty image)
        self._u_full   = snap["u"]
        self._v_full   = snap["v"]
        self._amp_full = snap["amp"]
        self._ph_full  = snap["phase"]

        # downsampled copy (used for the scatter plots)
        u, vv, amp, ph, n_total = _downsample(
            self._u_full, self._v_full, self._amp_full, self._ph_full)
        self._u_ds, self._v_ds, self._amp_ds, self._ph_ds = u, vv, amp, ph
        self._n_total = n_total

        central = QWidget()
        self.setCentralWidget(central)
        layout = QVBoxLayout(central)
        layout.setContentsMargins(6, 6, 6, 6)

        # ── info banner ────────────────────────────────────────────────────
        meta = snap["meta"]
        banner_text = f"{n_total} UV points"
        if n_total > u.size:
            banner_text += f"   (showing {u.size} subsampled in scatter plots)"
        extra = []
        if "FREQ" in meta:
            try:
                extra.append(f"f₀ = {float(meta['FREQ'])/1e6:.3f} MHz")
            except Exception:
                pass
        if "INTCOUNT" in meta:
            extra.append(f"int = {meta['INTCOUNT']} frames")
        if "DATE-OBS" in meta:
            extra.append(str(meta["DATE-OBS"]))
        if extra:
            banner_text += "   |   " + "   |   ".join(extra)
        banner = QLabel(banner_text)
        banner.setStyleSheet("color: #cccccc; font-size: 11px; padding: 2px 4px;")
        layout.addWidget(banner)

        # ── control row ────────────────────────────────────────────────────
        ctrl = QHBoxLayout()
        ctrl.setSpacing(10)

        ctrl.addWidget(QLabel("Amp colormap:"))
        self.amp_cmap_combo = QComboBox()
        self.amp_cmap_combo.addItems(_CMAP_CHOICES)
        self.amp_cmap_combo.setCurrentText("inferno")
        self.amp_cmap_combo.currentIndexChanged.connect(self._refresh_amp)
        ctrl.addWidget(self.amp_cmap_combo)

        ctrl.addWidget(QLabel("Amp clip %:"))
        self.amp_clip_combo = QComboBox()
        # (label, percentile-clipped-from-each-end)
        for label, pct in [("none", 0.0), ("0.5%", 0.5), ("1%", 1.0),
                           ("2%", 2.0), ("5%", 5.0), ("10%", 10.0)]:
            self.amp_clip_combo.addItem(label, pct)
        self.amp_clip_combo.setCurrentIndex(3)  # 2% default
        self.amp_clip_combo.setToolTip(
            "Clip the amplitude colormap to the [p, 100-p] percentile of "
            "log10|V|.\nUse a non-zero value to ignore extreme outliers "
            "and stretch the\ncolormap across the bulk of the data.")
        self.amp_clip_combo.currentIndexChanged.connect(self._refresh_amp)
        ctrl.addWidget(self.amp_clip_combo)

        self.show_phase_chk = QCheckBox("Show Phase plot")
        self.show_phase_chk.setChecked(True)
        self.show_phase_chk.toggled.connect(self._toggle_phase)
        ctrl.addWidget(self.show_phase_chk)

        self.show_dirty_chk = QCheckBox("Show Dirty Image")
        self.show_dirty_chk.setChecked(True)
        self.show_dirty_chk.toggled.connect(self._toggle_dirty)
        ctrl.addWidget(self.show_dirty_chk)

        ctrl.addWidget(QLabel("Dirty res:"))
        self.dirty_res_combo = QComboBox()
        for n in _GRID_CHOICES:
            self.dirty_res_combo.addItem(f"{n} × {n}", n)
        self.dirty_res_combo.setCurrentIndex(_GRID_CHOICES.index(256))
        self.dirty_res_combo.currentIndexChanged.connect(self._refresh_dirty)
        ctrl.addWidget(self.dirty_res_combo)

        ctrl.addWidget(QLabel("Dirty colormap:"))
        self.dirty_cmap_combo = QComboBox()
        self.dirty_cmap_combo.addItems(_CMAP_CHOICES)
        self.dirty_cmap_combo.setCurrentText("inferno")
        self.dirty_cmap_combo.currentIndexChanged.connect(self._refresh_dirty)
        ctrl.addWidget(self.dirty_cmap_combo)

        ctrl.addStretch(1)
        layout.addLayout(ctrl)

        # ── plots ──────────────────────────────────────────────────────────
        self.glw = pg.GraphicsLayoutWidget()
        layout.addWidget(self.glw, stretch=1)

        # Amplitude plot
        self.amp_plot = self.glw.addPlot(row=0, col=0)
        self.amp_plot.setTitle("UV Plane — Amplitude", **_TITLE_STYLE)
        self.amp_plot.setLabel("bottom", "u  (wavelengths)", **_LABEL_STYLE)
        self.amp_plot.setLabel("left",   "v  (wavelengths)", **_LABEL_STYLE)
        self.amp_plot.setAspectLocked(True)
        self.amp_plot.showGrid(x=True, y=True, alpha=0.2)
        self.amp_sc = pg.ScatterPlotItem(size=4, pen=None)
        self.amp_plot.addItem(self.amp_sc)

        # Phase plot
        self.phase_plot = self.glw.addPlot(row=0, col=1)
        self.phase_plot.setTitle("UV Plane — Phase", **_TITLE_STYLE)
        self.phase_plot.setLabel("bottom", "u  (wavelengths)", **_LABEL_STYLE)
        self.phase_plot.setLabel("left",   "v  (wavelengths)", **_LABEL_STYLE)
        self.phase_plot.setAspectLocked(True)
        self.phase_plot.showGrid(x=True, y=True, alpha=0.2)
        self.phase_sc = pg.ScatterPlotItem(size=4, pen=None)
        self.phase_plot.addItem(self.phase_sc)
        self.phase_plot.setXLink(self.amp_plot)
        self.phase_plot.setYLink(self.amp_plot)

        # Dirty image plot
        self.dirty_plot = self.glw.addPlot(row=0, col=2)
        self.dirty_plot.setTitle("Dirty Image (2D IFFT)", **_TITLE_STYLE)
        self.dirty_plot.setLabel("bottom", "l  (direction cosine)", **_LABEL_STYLE)
        self.dirty_plot.setLabel("left",   "m  (direction cosine)", **_LABEL_STYLE)
        self.dirty_plot.setAspectLocked(True)
        self.dirty_im = pg.ImageItem()
        self.dirty_plot.addItem(self.dirty_im)

        # initial render
        self._refresh_amp()
        self._refresh_phase()
        self._refresh_dirty()

        sb = QStatusBar()
        self.setStatusBar(sb)
        sb.showMessage(f"Loaded {fits_path}")

    # ── refresh helpers ───────────────────────────────────────────────────
    def _refresh_amp(self):
        _populate_uv_scatter(
            self.amp_sc, self.amp_plot,
            self._u_ds, self._v_ds, self._amp_ds, self._ph_ds,
            is_phase=False,
            cmap_name=self.amp_cmap_combo.currentText(),
            clip_pct=float(self.amp_clip_combo.currentData()),
        )

    def _refresh_phase(self):
        if not self.show_phase_chk.isChecked():
            return
        _populate_uv_scatter(
            self.phase_sc, self.phase_plot,
            self._u_ds, self._v_ds, self._amp_ds, self._ph_ds,
            is_phase=True,
        )

    def _refresh_dirty(self):
        if not self.show_dirty_chk.isChecked():
            return
        N = int(self.dirty_res_combo.currentData())
        self.statusBar().showMessage(f"Computing dirty image at {N}×{N} …")
        QApplication.processEvents()
        dirty_abs, lm = _compute_dirty(
            self._u_full, self._v_full, self._amp_full, self._ph_full, N)
        try:
            lut = _get_cmap(self.dirty_cmap_combo.currentText()).getLookupTable(0.0, 1.0, 256)
            self.dirty_im.setLookupTable(lut)
        except Exception:
            pass
        self.dirty_im.setImage(dirty_abs, autoLevels=False)
        if dirty_abs.max() > 0:
            self.dirty_im.setLevels((0.0, float(dirty_abs.max())))
        self.dirty_im.setRect(pg.QtCore.QRectF(-lm, -lm, 2 * lm, 2 * lm))
        self.dirty_plot.getViewBox().setRange(
            xRange=(-lm, lm), yRange=(-lm, lm), padding=0)
        self.statusBar().showMessage(
            f"Dirty image: {N}×{N},  l,m ∈ [-{lm:.3g}, +{lm:.3g}]")

    def _toggle_phase(self, on):
        self.phase_plot.setVisible(on)
        if on:
            self._refresh_phase()

    def _toggle_dirty(self, on):
        self.dirty_plot.setVisible(on)
        if on:
            self._refresh_dirty()


def main():
    parser = argparse.ArgumentParser(
        description="Standalone UV-plane viewer for FX_Correlator FITS files.")
    parser.add_argument("fits", nargs="?", default=None,
                        help="FITS file (UV export or dirty-image export). "
                             "If omitted, a file picker is shown.")
    args = parser.parse_args()

    app = QApplication(sys.argv)
    app.setApplicationName("FX_Correlator UV Viewer")
    app.setOrganizationName("FX_Correlator")
    _apply_dark_palette(app)

    fits_path = args.fits if (args.fits and os.path.isfile(args.fits)) else None
    if fits_path is None:
        fits_path, _ = QFileDialog.getOpenFileName(
            None, "Open FX_Correlator FITS",
            os.path.expanduser("~"),
            "FITS files (*.fits *.fit);;All files (*)",
        )
    if not fits_path:
        print("No file selected — exiting.")
        return 0

    try:
        snap = _load_uv_from_fits(fits_path)
    except Exception as e:
        QMessageBox.critical(None, "UV Viewer — Load Error", str(e))
        return 1

    print(f"Loaded {os.path.basename(fits_path)}")
    print(f"  UV samples : {snap['u'].size}")
    for k, val in snap["meta"].items():
        print(f"  {k:12s}: {val}")

    win = UVWindow(fits_path, snap)
    win.show()
    return app.exec_()


if __name__ == "__main__":
    sys.exit(main())
