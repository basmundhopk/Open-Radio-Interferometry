"""
Interactive CLEAN dialog.

Opens a separate non-modal window snapshotting the current UV-plane
accumulator. Computes the dirty image and PSF once, then lets the user
step the Hogbom CLEAN loop interactively (single iteration, batches of
10 / 100 / 1000, or run to convergence). The three panels show:

  - Dirty image       (frozen at snapshot time)
  - CLEAN image       (= components ⊛ clean_beam + residual)
  - Residual          (the current dirty-minus-components map)

Functions:
  - CleanDialog(QDialog)   :  the interactive window
"""

import time

import numpy as np
import pyqtgraph as pg

pg.setConfigOptions(
    antialias=True,
    background="#1e1e1e",
    foreground="#cccccc",
    imageAxisOrder="row-major",
    useOpenGL=False,
)

from PyQt5.QtCore import QRectF, Qt
from PyQt5.QtGui import QCursor, QKeySequence
from PyQt5.QtWidgets import (
    QAction,
    QApplication,
    QComboBox,
    QDialog,
    QDoubleSpinBox,
    QFileDialog,
    QGridLayout,
    QGroupBox,
    QHBoxLayout,
    QLabel,
    QMenu,
    QMessageBox,
    QPushButton,
    QShortcut,
    QSizePolicy,
    QSpinBox,
    QVBoxLayout,
)

from open_radio_interferometry.imaging.clean import (
    _fit_psf_gaussian,
    _gaussian_2d,
    _grid_uv,
    _ifft_image,
)


def _get_cmap(name, fallback="inferno"):
    """Return a pyqtgraph ColorMap for `name`, falling back if unknown."""
    try:
        cm = pg.colormap.get(name, source="matplotlib", skipCache=False)
        if cm is not None:
            return cm
    except Exception:
        pass
    try:
        return pg.colormap.get(fallback, source="matplotlib")
    except Exception:
        return pg.colormap.get("viridis")


_TITLE_STYLE = {"color": "#dddddd", "size": "10pt"}
_LABEL_STYLE = {"color": "#cccccc", "font-size": "8pt"}

# Sequential / scientific colormaps (matches ui.py:_CMAP_CHOICES)
_CMAP_CHOICES = [
    "inferno", "magma", "plasma", "viridis", "cividis", "turbo",
    "jet", "hot", "cubehelix", "gray", "bone", "afmhot",
]


class CleanDialog(QDialog):
    """
    Non-modal interactive CLEAN window.

    Parameters
    ----------
    u, v, amp, phase : 1-D numpy arrays
        Snapshot of the UV accumulator at dialog-open time.
    grid_size : int
        Image dimension N (image is NxN).
    gain, threshold, max_iter : float, float, int
        Initial CLEAN parameters (still tunable in the dialog).
    cmap : str
        Matplotlib colormap (uses the user's "dirty_cmap" choice).
    parent : QWidget or None
        Parent for proper Qt parenting / dark palette inheritance.
    """

    def __init__(self, u, v, amp, phase, grid_size,
                 gain=0.1, threshold=0.05, max_iter=1000,
                 cmap="inferno", parent=None):
        super().__init__(parent)
        self.setWindowTitle("Interactive CLEAN — Hogbom")
        # Allow the user to resize, maximize, and minimize this window.
        # QDialog by default hides the maximize button — add it explicitly.
        self.setWindowFlags(
            Qt.Window
            | Qt.WindowTitleHint
            | Qt.WindowSystemMenuHint
            | Qt.WindowMinimizeButtonHint
            | Qt.WindowMaximizeButtonHint
            | Qt.WindowCloseButtonHint
        )
        self.setSizeGripEnabled(True)
        self.setMinimumSize(640, 520)
        self.resize(1200, 1050)
        # Non-modal so the user can keep watching the live UV plot too
        self.setModal(False)

        self._cmap = cmap

        # Store UV snapshot — never mutated, used to regrid at any N
        self._u     = np.asarray(u, dtype=np.float64)
        self._v     = np.asarray(v, dtype=np.float64)
        self._amp   = np.asarray(amp, dtype=np.float64)
        self._phase = np.asarray(phase, dtype=np.float64)

        # Initial grid at requested resolution
        self._regrid(int(grid_size), rebuild_images=False)

        self._build_ui(gain, threshold, max_iter)
        self._refresh_displays(initial=True)

    # ── (re)grid the UV data at resolution N ──────────────────────────────
    def _regrid(self, N, rebuild_images=True):
        """
        Build dirty image + PSF at image size NxN from the stored UV
        snapshot. Resets the CLEAN state (residual / components / iter).
        If rebuild_images is True, also resizes the 4 imshow panels to
        the new N and updates their extents.
        """
        N = int(N)
        self._N = N

        vis = self._amp * np.exp(1j * self._phase)
        vis_grid, _wt, uv_max = _grid_uv(self._u, self._v, vis, N)
        self._uv_max = float(uv_max)
        _dirty_complex = np.fft.ifftshift(np.fft.ifft2(np.fft.fftshift(vis_grid)))
        # For display, clip negatives rather than np.abs(): rectifying the
        # signed image folds PSF sidelobes back as bright stripes and turns
        # zero crossings into hard black lines.
        self._dirty_abs = np.clip(_dirty_complex.real, 0.0, None).astype(np.float64)
        # Hogbom operates on .real (signed peaks, physically correct for
        # Hermitian-symmetric visibilities).
        self._dirty = _dirty_complex.real

        unit = np.ones_like(vis)
        psf_grid, _wt2, _ = _grid_uv(self._u, self._v, unit, N, uv_max=uv_max)
        psf = _ifft_image(psf_grid)
        peak = np.abs(psf).max()
        if peak > 0:
            psf = psf / peak
        self._psf = psf
        self._beam_sigma = _fit_psf_gaussian(self._psf)

        # CLEAN state — reset
        self._residual   = self._dirty.copy()
        self._components = np.zeros_like(self._dirty)
        self._n_iter     = 0
        self._initial_peak = float(np.abs(self._dirty).max())
        # Cached derived panels (filled in by _refresh_displays). At iter 0
        # the model is zero and the restored image equals the dirty image.
        self._model_img    = np.zeros_like(self._dirty)
        self._restored_img = self._dirty.copy()

        # cell size in direction-cosine units
        dl = 1.0 / (2.0 * self._uv_max)
        self._lm_extent = dl * N / 2.0

        if rebuild_images:
            blank = np.zeros_like(self._dirty)
            for im in (self._im_dirty, self._im_clean,
                       self._im_resid, self._im_restr):
                im.setImage(blank, autoLevels=False)
                im.setRect(QRectF(-self._lm_extent, -self._lm_extent,
                                  2 * self._lm_extent, 2 * self._lm_extent))

    # ── UI construction ───────────────────────────────────────────────────
    def _build_ui(self, gain, threshold, max_iter):
        root = QVBoxLayout(self)

        # control bar
        ctrl_row = QHBoxLayout()

        # parameters group (2x2 grid: label + spin per cell)
        param_grp = QGroupBox("Parameters")
        pg_layout = QGridLayout()
        pg_layout.setHorizontalSpacing(8)
        pg_layout.setVerticalSpacing(4)

        self.gain_spin = QDoubleSpinBox()
        self.gain_spin.setRange(0.01, 1.0)
        self.gain_spin.setDecimals(2)
        self.gain_spin.setSingleStep(0.05)
        self.gain_spin.setValue(gain)

        self.threshold_spin = QDoubleSpinBox()
        self.threshold_spin.setRange(0.0001, 1.0)
        self.threshold_spin.setDecimals(4)
        self.threshold_spin.setSingleStep(0.01)
        self.threshold_spin.setValue(threshold)
        self.threshold_spin.setSuffix("  × peak")

        self.max_iter_spin = QSpinBox()
        self.max_iter_spin.setRange(1, 1000000)
        self.max_iter_spin.setSingleStep(100)
        self.max_iter_spin.setValue(max_iter)

        # Image resolution (re-grids the UV snapshot on change)
        self.res_combo = QComboBox()
        _RES_CHOICES = [64, 128, 192, 256, 384, 512, 768,
                        1024, 1536, 2048, 3072, 4096]
        choices = sorted(set(_RES_CHOICES + [self._N]))
        for n in choices:
            self.res_combo.addItem(f"{n} × {n}", n)
        self.res_combo.setCurrentIndex(choices.index(self._N))
        self.res_combo.setToolTip(
            "Image grid size (NxN). Changing this re-grids the UV "
            "snapshot and resets the CLEAN state.")

        # Colormap selector — applies to all four image panels
        self.cmap_combo = QComboBox()
        for name in _CMAP_CHOICES:
            self.cmap_combo.addItem(name)
        _ci = self.cmap_combo.findText(self._cmap)
        self.cmap_combo.setCurrentIndex(_ci if _ci >= 0 else 0)
        self.cmap_combo.setToolTip("Colormap used for all four image panels.")

        # 2x2 layout: (Loop Gain | Threshold) / (Run-All Cap | Resolution)
        cells = [
            ("Loop Gain:",   self.gain_spin),
            ("Threshold:",   self.threshold_spin),
            ("Run-All Cap:", self.max_iter_spin),
            ("Resolution:",  self.res_combo),
            ("Colormap:",    self.cmap_combo),
        ]
        for i, (text, widget) in enumerate(cells):
            r, c = divmod(i, 2)
            lbl = QLabel(text)
            lbl.setAlignment(Qt.AlignRight | Qt.AlignVCenter)
            pg_layout.addWidget(lbl,    r, 2 * c)
            pg_layout.addWidget(widget, r, 2 * c + 1)

        param_grp.setLayout(pg_layout)
        ctrl_row.addWidget(param_grp)

        # step buttons (compact column on the right)
        step_grp = QGroupBox("Iterate")
        sl = QHBoxLayout()
        sl.setContentsMargins(6, 4, 6, 4)
        sl.setSpacing(4)
        self.btn_1    = QPushButton("+1")
        self.btn_10   = QPushButton("+10")
        self.btn_100  = QPushButton("+100")
        self.btn_1000 = QPushButton("+1000")
        self.btn_run  = QPushButton("▶  Run")
        self.btn_reset= QPushButton("↺  Reset")
        self.btn_rescale = QPushButton("🔆  Rescale")
        self.btn_rescale.setToolTip(
            "Re-stretch every panel's brightness range to its current "
            "min/max. After rescaling, the on-screen view matches what "
            "would be saved as PNG.")
        self.btn_run.setToolTip("Run to convergence (or stop if already running)")
        for b in (self.btn_1, self.btn_10, self.btn_100, self.btn_1000):
            b.setMinimumWidth(56)
            b.setMaximumWidth(80)
        for b in (self.btn_run, self.btn_reset, self.btn_rescale):
            b.setMinimumWidth(90)
        for b in (self.btn_1, self.btn_10, self.btn_100, self.btn_1000,
                  self.btn_run, self.btn_rescale, self.btn_reset):
            b.setMinimumHeight(36)
            sl.addWidget(b)
        step_grp.setLayout(sl)
        # status line lives directly under the Iterate row so it doesn't
        # consume an extra full-width strip above the plots.
        self.status_lbl = QLabel("ready  —  right-click any panel to save it")
        self.status_lbl.setStyleSheet(
            "font-size: 11px; color: #cccccc; padding: 2px 6px;")

        right_col = QVBoxLayout()
        right_col.setContentsMargins(0, 0, 0, 0)
        right_col.setSpacing(2)
        right_col.addWidget(step_grp)
        right_col.addWidget(self.status_lbl)
        right_col.addStretch(1)
        ctrl_row.addLayout(right_col, 1)
        root.addLayout(ctrl_row)

        # ---- pyqtgraph 2x2 panel grid -----------------------------------
        self.gview = pg.GraphicsLayoutWidget()
        self.gview.setBackground("#1e1e1e")
        self.gview.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        self.gview.setMinimumSize(300, 300)

        cmap = _get_cmap(self._cmap)
        lut = cmap.getLookupTable(0.0, 1.0, 256)

        def _make_panel(row, col, title):
            plot = self.gview.addPlot(row=row, col=col)
            plot.setAspectLocked(True)
            plot.setMenuEnabled(False)
            plot.showGrid(x=False, y=False)
            plot.setLabel("bottom", "l  (rad)", **_LABEL_STYLE)
            plot.setLabel("left",   "m  (rad)", **_LABEL_STYLE)
            plot.setTitle(title, **_TITLE_STYLE)
            img = pg.ImageItem(axisOrder="row-major")
            img.setLookupTable(lut)
            plot.addItem(img)
            return plot, img

        ext = self._lm_extent
        rect = QRectF(-ext, -ext, 2 * ext, 2 * ext)
        blank = np.zeros_like(self._dirty)

        self.ax_dirty, self._im_dirty = _make_panel(0, 0, "Dirty Image (snapshot)")
        self.ax_clean, self._im_clean = _make_panel(0, 1, "Model  (components ⊛ clean beam)")
        self.ax_resid, self._im_resid = _make_panel(1, 0, "Residual")
        self.ax_restr, self._im_restr = _make_panel(1, 1, "Restored  (model + residual)")
        for im in (self._im_dirty, self._im_clean,
                   self._im_resid, self._im_restr):
            im.setImage(blank, autoLevels=False)
            im.setRect(rect)

        # Track current display levels per panel (pyqtgraph equivalent of clim)
        self._dirty_clim = (0.0, 1.0)

        root.addWidget(self.gview, 1)

        # connect buttons
        self.btn_1.clicked.connect(lambda: self._step(1))
        self.btn_10.clicked.connect(lambda: self._step(10))
        self.btn_100.clicked.connect(lambda: self._step(100))
        self.btn_1000.clicked.connect(lambda: self._step(1000))
        self.btn_run.clicked.connect(self._run_to_convergence)
        self.btn_reset.clicked.connect(self._reset)
        self.btn_rescale.clicked.connect(self._rescale_panels)
        self.res_combo.currentIndexChanged.connect(self._on_resolution_changed)
        self.cmap_combo.currentIndexChanged.connect(self._on_cmap_changed)

        # F11 toggles fullscreen, Esc leaves fullscreen
        self._fs_shortcut = QShortcut(QKeySequence("F11"), self)
        self._fs_shortcut.activated.connect(self._toggle_fullscreen)
        self._esc_shortcut = QShortcut(QKeySequence("Esc"), self)
        self._esc_shortcut.activated.connect(self._leave_fullscreen)

        # Right-click on any panel → "Save this panel…" menu.
        self.gview.scene().sigMouseClicked.connect(self._on_canvas_click)

    # ── right-click "Save panel" ───────────────────────────────────────────
    def _on_canvas_click(self, event):
        if event.button() != Qt.RightButton:
            return
        scene_pos = event.scenePos()
        ax_map = {
            self.ax_dirty: ("Dirty",    lambda: self._dirty,        self._im_dirty),
            self.ax_clean: ("Model",    lambda: self._model_img,    self._im_clean),
            self.ax_resid: ("Residual", lambda: self._residual,     self._im_resid),
            self.ax_restr: ("Restored", lambda: self._restored_img, self._im_restr),
        }
        hit = None
        for plot, info in ax_map.items():
            vb = plot.getViewBox()
            if vb.sceneBoundingRect().contains(scene_pos):
                hit = info
                break
        if hit is None:
            return
        label, getter, live_im = hit

        menu = QMenu(self)
        act_png  = QAction(f"Save {label} as PNG…",  self)
        act_fits = QAction(f"Save {label} as FITS…", self)
        menu.addAction(act_png)
        menu.addAction(act_fits)
        act_png .triggered.connect(lambda: self._save_panel_png(label, getter(), live_im))
        act_fits.triggered.connect(lambda: self._save_panel_fits(label, getter()))
        menu.exec_(QCursor.pos())

    def _rescale_panels(self):
        """Re-stretch every panel to its own current min/max."""
        for im in (self._im_dirty, self._im_clean,
                   self._im_resid, self._im_restr):
            arr = im.image
            if arr is None:
                continue
            a = np.asarray(arr)
            vmin = float(a.min())
            vmax = float(a.max())
            if vmax <= vmin:
                vmax = vmin + 1e-30
            im.setLevels((vmin, vmax))
        # Stop _refresh_displays from re-imposing the dirty-image levels
        # on every iteration. Reset / Resolution-change clear this back.
        self._manual_levels = True
        self.status_lbl.setText(
            "rescaled — each panel now stretched to its own min/max "
            "(saved PNG will match)")

    def _save_panel_png(self, label, data, live_im=None):
        """Save a single panel as a standalone PNG with title, colorbar,
        and l/m axis labels — the kind of figure you'd drop into a paper.
        Copies the on-screen clim from live_im so the export matches what
        you see in the app (otherwise matplotlib auto-rescales on save
        and the PNG looks brighter or darker than the panel)."""
        if data is None:
            QMessageBox.warning(self, "Save panel",
                                "Nothing to save yet — run CLEAN first.")
            return
        default = f"clean_{label.lower()}_iter{self._n_iter}.png"
        path, _ = QFileDialog.getSaveFileName(
            self, f"Save {label} as PNG", default,
            "PNG image (*.png);;PDF (*.pdf);;SVG (*.svg);;All files (*)")
        if not path:
            return

        # Match the on-screen colour stretch.
        if live_im is not None:
            lv = live_im.getLevels()
            if lv is not None:
                vmin, vmax = float(lv[0]), float(lv[1])
            else:
                arr = np.abs(data)
                vmin, vmax = float(arr.min()), float(arr.max())
        else:
            arr = np.abs(data)
            vmin, vmax = float(arr.min()), float(arr.max())
        if vmax <= vmin:
            vmax = vmin + 1e-30

        # Make a dedicated standalone figure (so we don't disturb the
        # interactive canvas) with matching styling.
        from matplotlib.backends.backend_agg import FigureCanvasAgg
        from matplotlib.figure import Figure
        fig = Figure(figsize=(7, 6), dpi=150, facecolor="#1e1e1e",
                     constrained_layout=True)
        FigureCanvasAgg(fig)
        ax = fig.add_subplot(1, 1, 1)
        ax.set_facecolor("#1a1a1a")
        ax.tick_params(colors="#cccccc")
        for s in ax.spines.values():
            s.set_color("#666666")
        ext = [-self._lm_extent, self._lm_extent,
               -self._lm_extent, self._lm_extent]
        im = ax.imshow(np.abs(data), origin="lower", cmap=self._cmap,
                       extent=ext, aspect="equal", interpolation="nearest",
                       vmin=vmin, vmax=vmax)
        ax.set_xlabel("l  (rad)", color="#cccccc")
        ax.set_ylabel("m  (rad)", color="#cccccc")
        title = (f"{label}   (N={self._N}, iter={self._n_iter}, "
                 f"FWHM={2.3548*self._beam_sigma:.2f} px)")
        ax.set_title(title, color="#dddddd")
        cbar = fig.colorbar(im, ax=ax, fraction=0.046, pad=0.04)
        cbar.ax.tick_params(colors="#cccccc")
        try:
            fig.savefig(path, facecolor=fig.get_facecolor())
            self.status_lbl.setText(f"saved {label} → {path}")
        except Exception as e:
            QMessageBox.critical(self, "Save panel",
                                 f"Failed to save:\n{e}")

    def _save_panel_fits(self, label, data):
        """Save a single panel as a 2-D FITS image with l/m WCS (simple
        linear TAN-style axes in radians; good enough for re-loading in
        DS9 / astropy). The real-valued data is written (not |·|)."""
        if data is None:
            QMessageBox.warning(self, "Save panel",
                                "Nothing to save yet — run CLEAN first.")
            return
        try:
            from astropy.io import fits
        except ImportError:
            QMessageBox.critical(
                self, "Save panel",
                "astropy is required — install with  pip install astropy")
            return
        default = f"clean_{label.lower()}_iter{self._n_iter}.fits"
        path, _ = QFileDialog.getSaveFileName(
            self, f"Save {label} as FITS", default,
            "FITS image (*.fits *.fit);;All files (*)")
        if not path:
            return

        N = int(self._N)
        arr = np.asarray(data, dtype=np.float32)
        hdu = fits.PrimaryHDU(arr)
        h = hdu.header
        # Simple direction-cosine (l, m) WCS in radians — not celestial,
        # but standard enough that DS9 / astropy will show coordinates.
        cell = 1.0 / (2.0 * self._uv_max)  # radians per pixel
        h["CTYPE1"] = "L"
        h["CTYPE2"] = "M"
        h["CUNIT1"] = "rad"
        h["CUNIT2"] = "rad"
        h["CRPIX1"] = N / 2 + 1
        h["CRPIX2"] = N / 2 + 1
        h["CRVAL1"] = 0.0
        h["CRVAL2"] = 0.0
        h["CDELT1"] = cell
        h["CDELT2"] = cell
        h["BUNIT"]  = "JY/BEAM" if label in ("Model", "Restored") else "JY"
        h["OBJECT"] = label.upper()
        h["HISTORY"] = f"FX_Correlator CLEAN panel '{label}'"
        h["HISTORY"] = f"  iterations   = {self._n_iter}"
        h["HISTORY"] = f"  grid size    = {N} x {N}"
        h["HISTORY"] = f"  beam FWHM    = {2.3548*self._beam_sigma:.3f} px"
        h["HISTORY"] = f"  UV samples   = {self._u.size}"
        try:
            hdu.writeto(path, overwrite=True)
            self.status_lbl.setText(f"saved {label} → {path}")
        except Exception as e:
            QMessageBox.critical(self, "Save panel",
                                 f"Failed to save:\n{e}")

    def _toggle_fullscreen(self):
        if self.isFullScreen():
            self.showNormal()
        else:
            self.showFullScreen()

    def _leave_fullscreen(self):
        if self.isFullScreen():
            self.showNormal()

    # ── colormap change ────────────────────────────────────────────────────
    def _on_cmap_changed(self, idx):
        name = self.cmap_combo.currentText()
        self._cmap = name
        lut = _get_cmap(name).getLookupTable(0.0, 1.0, 256)
        for im in (self._im_dirty, self._im_clean,
                   self._im_resid, self._im_restr):
            im.setLookupTable(lut)
        self.status_lbl.setText(f"colormap → {name}")

    # ── resolution change ──────────────────────────────────────────────────
    def _on_resolution_changed(self, idx):
        new_N = int(self.res_combo.itemData(idx))
        if new_N == self._N:
            return
        # Heads-up for large grids — regridding 4096² takes a few seconds
        if new_N >= 2048:
            self.status_lbl.setText(
                f"re-gridding at {new_N}×{new_N} … please wait")
            QApplication.processEvents()
        t0 = time.time()
        self._regrid(new_N, rebuild_images=True)
        self._refresh_displays(initial=True)
        dt_ms = (time.time() - t0) * 1000.0
        self.status_lbl.setText(
            f"re-gridded at {new_N}×{new_N} in {dt_ms:.0f} ms "
            f"— CLEAN state reset")

    # ── core operations ────────────────────────────────────────────────────
    def _step(self, n):
        """Run n more Hogbom iterations on the current residual."""
        if self._psf is None or n <= 0:
            return
        gain = float(self.gain_spin.value())
        threshold = float(self.threshold_spin.value())
        # threshold must be referenced to the INITIAL dirty peak so that the
        # stop condition is consistent across step batches.
        # hogbom_clean takes a relative threshold but computes its own
        # initial peak from the input it sees. To keep semantics consistent
        # we override by computing the absolute stop level ourselves.
        abs_stop = threshold * self._initial_peak

        t0 = time.time()
        # Run Hogbom but cap at n; we manage the threshold externally.
        # Pass a tiny relative threshold so it only exits on max_iter or
        # when it would otherwise stop. We then check abs_stop separately.
        new_components, new_residual, n_done = _stepwise_hogbom(
            self._residual, self._psf, gain=gain,
            abs_stop=abs_stop, max_iter=n,
        )
        elapsed_ms = (time.time() - t0) * 1000.0

        self._residual = new_residual
        self._components += new_components
        self._n_iter += n_done

        self._refresh_displays(elapsed_ms=elapsed_ms, batch=n_done, requested=n)

    def _run_to_convergence(self):
        """Run up to Run-All Cap iterations or until the threshold is met,
        repainting after every single iteration so the panels animate."""
        cap = int(self.max_iter_spin.value())
        gain = float(self.gain_spin.value())
        abs_stop = float(self.threshold_spin.value()) * self._initial_peak
        t0 = time.time()
        total = 0
        # Allow the user to interrupt by clicking the button again.
        if getattr(self, "_running", False):
            self._stop_requested = True
            return
        self._running = True
        self._stop_requested = False
        original_text = self.btn_run.text()
        self.btn_run.setText("■  Stop")
        try:
            for _ in range(cap):
                new_components, new_residual, n_done = _stepwise_hogbom(
                    self._residual, self._psf, gain=gain,
                    abs_stop=abs_stop, max_iter=1,
                )
                if n_done == 0:
                    break  # threshold met
                self._residual = new_residual
                self._components += new_components
                self._n_iter += n_done
                total += n_done
                self._refresh_displays(
                    elapsed_ms=(time.time() - t0) * 1000.0,
                    batch=total, requested=cap, partial=True,
                )
                QApplication.processEvents()
                if self._stop_requested:
                    break
        finally:
            self._running = False
            self._stop_requested = False
            self.btn_run.setText(original_text)
        self._refresh_displays(elapsed_ms=(time.time() - t0) * 1000.0,
                               batch=total, requested=cap)

    def _reset(self):
        """Discard all components and start CLEAN over from the snapshot."""
        self._residual = self._dirty.copy()
        self._components.fill(0.0)
        self._n_iter = 0
        self._refresh_displays(initial=True)

    # ── display refresh ────────────────────────────────────────────────────
    def _refresh_displays(self, initial=False, elapsed_ms=None,
                          batch=None, requested=None, partial=False):
        # We display |·| of every panel so they match the live "Dirty Image
        # (2D IFFT)" panel (which also shows magnitude) and so positive and
        # negative CLEAN components both register visually.
        if initial:
            # A fresh snapshot / reset / re-grid clears any manual stretch.
            self._manual_levels = False
            # Display |·| of the dirty image; record its level range as the
            # shared baseline for the Residual + Restored panels.
            d_abs = np.abs(self._dirty)
            dmin, dmax = float(d_abs.min()), float(d_abs.max())
            if dmax <= dmin:
                dmax = dmin + 1e-30
            self._dirty_clim = (dmin, dmax)
            self._im_dirty.setImage(d_abs, autoLevels=False, levels=(dmin, dmax))

        # Show the MODEL image (components convolved with the clean beam,
        # no residual added back) rather than the conventional full
        # restored image. The model image starts black and visibly builds
        # up as CLEAN finds point-sources.
        N = self._components.shape[0]
        beam = _gaussian_2d(N, self._beam_sigma, self._beam_sigma)
        F_b = np.fft.fft2(np.fft.ifftshift(beam))
        F_c = np.fft.fft2(self._components)
        model_img = np.real(np.fft.ifft2(F_c * F_b))
        m_abs = np.abs(model_img)
        m_max = float(m_abs.max())
        if m_max <= 0:
            m_max = 1e-30

        if self._manual_levels:
            # User hit Rescale — keep their per-panel levels intact.
            self._im_clean.setImage(m_abs, autoLevels=False)
            self._im_resid.setImage(np.abs(self._residual), autoLevels=False)
            restored_img = model_img + self._residual
            self._im_restr.setImage(np.abs(restored_img), autoLevels=False)
        else:
            # Default behaviour: model auto-levels from 0→peak; residual +
            # restored share the dirty image's level range.
            self._im_clean.setImage(m_abs, autoLevels=False, levels=(0.0, m_max))
            dmin, dmax = self._dirty_clim
            self._im_resid.setImage(np.abs(self._residual),
                                    autoLevels=False, levels=(dmin, dmax))
            restored_img = model_img + self._residual
            self._im_restr.setImage(np.abs(restored_img),
                                    autoLevels=False, levels=(dmin, dmax))

        # Cache the latest real-valued panels so "Save this panel" can
        # export them as FITS (without the |·| display squashing).
        self._model_img    = model_img
        self._restored_img = restored_img

        # Status line
        peak_resid = float(np.abs(self._residual).max())
        std_resid  = float(np.std(self._residual))
        n_comp = int(np.count_nonzero(self._components))
        dr = self._initial_peak / std_resid if std_resid > 1e-30 else 0.0
        peak_pct = 100.0 * peak_resid / self._initial_peak if self._initial_peak > 0 else 0.0

        bits = [
            f"iter: {self._n_iter}",
            f"comps: {n_comp}",
            f"peak/init: {peak_pct:.2f}%",
            f"DR: {dr:.1f}",
            f"FWHM: {2.3548*self._beam_sigma:.2f} px",
        ]
        if elapsed_ms is not None and batch is not None:
            tag = "batch" if not partial else "partial"
            bits.append(f"{tag}: {batch}/{requested} in {elapsed_ms:.0f} ms")
        self.status_lbl.setText("   |   ".join(bits))


# ── helper: stepwise Hogbom with absolute stop level ────────────────────────
def _stepwise_hogbom(dirty, psf, gain, abs_stop, max_iter):
    """
    Hogbom CLEAN inner loop with an absolute stop level and per-call
    iteration cap. Returns (components, residual, n_done).

    IMPORTANT: subtraction uses **circular (wrapped) shifts** via
    ``np.roll`` so the subtraction properly inverts the circular
    convolution implicit in FFT-based gridding. A clipped (non-wrapping)
    subtraction leaves behind the aliased portion of each source's
    sidelobes every iteration, which stack up into a diagonal grating
    pattern and eventually cause the residual to *grow* instead of
    shrink. Using wraparound fixes that.
    """
    N = dirty.shape[0]
    residual = dirty.astype(np.float64).copy()
    components = np.zeros_like(residual)
    psf_max = np.abs(psf).max()
    if psf_max <= 0:
        return components, residual, 0
    psf_n = np.asarray(psf, dtype=np.float64) / psf_max
    psf_cy, psf_cx = N // 2, N // 2

    for it in range(max_iter):
        idx = np.argmax(np.abs(residual))
        py, px = np.unravel_index(idx, residual.shape)
        peak_val = residual[py, px]
        if abs(peak_val) < abs_stop:
            return components, residual, it
        amp = gain * peak_val
        components[py, px] += amp
        # Circular-shift the PSF so its center lands at (py, px), then
        # subtract the scaled PSF from the whole residual. This matches
        # the periodic boundary condition of the FFT-based gridder, so
        # aliased sidelobes are removed correctly.
        shift_y = py - psf_cy
        shift_x = px - psf_cx
        residual -= amp * np.roll(psf_n, (shift_y, shift_x), axis=(0, 1))

    return components, residual, max_iter
