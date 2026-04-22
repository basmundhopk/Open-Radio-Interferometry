#!/usr/bin/env python3
"""
Standalone interactive CLEAN (Hogbom) deconvolution app.

Opens a FITS file produced by the FX_Correlator main app (or any compatible
radio-astronomy FITS with a UV_DATA BinTable) and launches the interactive
CleanDialog window. Step the Hogbom CLEAN loop one, ten, hundred, or
thousand iterations at a time and watch dirty / model / residual / restored
panels update live.

Supported input formats:

  1. Dirty-image FITS from FX_Correlator  (with PSF + UV_DATA extensions)
     -> CLEAN uses the embedded UV_DATA to rebuild the PSF exactly.

  2. UV-only FITS from FX_Correlator      (with UV_DATA BinTable)
     -> CLEAN grids the UV data itself to produce dirty image + PSF.

  3. Any FITS with an HDU named "UV_DATA" containing U/V/AMP/PHASE columns.

Usage:
    python3 clean_app.py  [fits_file] [-N GRID]

Examples:
    python3 clean_app.py                       # file-picker
    python3 clean_app.py dirty.fits            # use FITS GRIDSIZE as initial
    python3 clean_app.py dirty.fits -N 1024    # open with 1024×1024 initial

The image resolution can be changed at any time from the "Resolution" combo
inside the CLEAN window (64 … 4096). Changing resolution re-grids the UV
snapshot and resets the CLEAN state.

Requires:  astropy, numpy, matplotlib, PyQt5.

Functions:
  - _apply_dark_palette(app):     apply dark theme palette to QApplication
  - _load_uv_from_fits(path):     read U/V/AMP/PHASE + grid_size from a FITS
  - main():                       application entry point
"""

import sys
import os
import argparse
import numpy as np

import matplotlib
matplotlib.use("Qt5Agg")

from PyQt5.QtWidgets import (
    QApplication, QFileDialog, QMessageBox, QDialog,
)
from PyQt5.QtGui import QPalette, QColor
from PyQt5.QtCore import Qt

from clean_dialog import CleanDialog


# ── dark palette (matches the main app) ─────────────────────────────────────
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


# ── FITS loader ─────────────────────────────────────────────────────────────
def _load_uv_from_fits(path):
    """
    Read visibilities from a FITS file written by FX_Correlator (or any
    compatible file with a UV_DATA BinTable HDU containing U, V, AMP, PHASE
    columns). Returns a dict with keys:
        u, v, amp, phase  : 1-D float64 numpy arrays
        grid_size         : int (from GRIDSIZE keyword, else 128)
        meta              : dict of extra FITS header keywords for display
    Raises RuntimeError on any problem.
    """
    try:
        from astropy.io import fits
    except ImportError:
        raise RuntimeError("astropy is required — install with  pip install astropy")

    with fits.open(path) as hdul:
        # find the UV_DATA HDU
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

        # grid size: prefer primary header, else default to 128
        N = int(hdul[0].header.get("GRIDSIZE", 128))

        # pull a few keywords for the window title
        meta = {}
        for k in ("DATE-OBS", "FREQ", "INTCOUNT", "N_UV_PTS",
                  "OBS_LAT", "OBS_LON", "TELESCOP", "OBJECT"):
            if k in hdul[0].header:
                meta[k] = hdul[0].header[k]

    return {
        "u": u, "v": v, "amp": amp, "phase": phase,
        "grid_size": N, "meta": meta,
    }


def main():
    parser = argparse.ArgumentParser(
        description="Standalone interactive Hogbom CLEAN for FX_Correlator FITS.")
    parser.add_argument("fits", nargs="?", default=None,
                        help="FITS file (UV export or dirty-image export). "
                             "If omitted, a file-picker is shown.")
    parser.add_argument("-N", "--grid-size", type=int, default=None,
                        help="Initial image grid size (NxN). Overrides the "
                             "FITS GRIDSIZE keyword. Resolution can also be "
                             "changed interactively inside the app.")
    args = parser.parse_args()

    app = QApplication(sys.argv)
    app.setApplicationName("FX_Correlator CLEAN")
    app.setOrganizationName("FX_Correlator")
    _apply_dark_palette(app)

    fits_path = args.fits if (args.fits and os.path.isfile(args.fits)) else None

    # fallback: file-picker
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
        QMessageBox.critical(None, "CLEAN — Load Error", str(e))
        return 1

    meta = snap["meta"]
    fits_N = int(snap["grid_size"])

    # Initial resolution: CLI override, else FITS default.
    N = int(args.grid_size) if args.grid_size is not None else fits_N
    if N < 16 or N > 8192:
        QMessageBox.critical(None, "CLEAN — Bad resolution",
                             f"Grid size {N} out of range (16..8192).")
        return 1

    print(f"Loaded {os.path.basename(fits_path)}")
    print(f"  UV samples : {snap['u'].size}")
    print(f"  FITS GRIDSIZE : {fits_N}")
    print(f"  initial grid : {N} x {N}  (change inside the app)")
    for k, val in meta.items():
        print(f"  {k:12s}: {val}")

    dlg = CleanDialog(
        u=snap["u"], v=snap["v"],
        amp=snap["amp"], phase=snap["phase"],
        grid_size=N,
        gain=0.1, threshold=0.05, max_iter=1000,
        cmap="inferno", parent=None,
    )
    title = f"Interactive CLEAN — {os.path.basename(fits_path)}"
    obj = meta.get("OBJECT")
    if obj and obj != "UNKNOWN":
        title += f"  [{obj}]"
    dlg.setWindowTitle(title)
    # make it a top-level window (standalone — not modal)
    dlg.setModal(False)
    dlg.setWindowFlag(Qt.Window, True)
    dlg.show()

    rc = app.exec_()
    return rc


if __name__ == "__main__":
    sys.exit(main())
