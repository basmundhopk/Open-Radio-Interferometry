"""
CLEAN deconvolution algorithms (Hogbom 1974).

Pure-Python implementation of image-plane CLEAN used by the interactive
CleanDialog (ui / standalone clean_app.py). No multiprocessing worker —
CLEAN runs in-process since it's fast enough for interactive stepping on
128² images (~1 ms / 100 iterations).

Functions:
  - _grid_uv(...)        :  grid (u,v,vis) onto an N x N complex visibility grid
  - _ifft_image(...)     :  centred 2-D IFFT producing a real image
  - _gaussian_2d(...)    :  evaluate a 2-D Gaussian on a grid (used as clean beam)
  - _fit_psf_gaussian(...): fit Gaussian FWHM to PSF main lobe (least-squares)
  - hogbom_clean(...)    :  Hogbom CLEAN inner loop (returns components + residual)
  - run_clean(...)       :  full CLEAN pipeline (grid -> dirty + PSF -> CLEAN -> restore)
"""

import time

import numpy as np


# ── gridding & imaging primitives ────────────────────────────────────────────
def _grid_uv(u, v, vis, N, uv_max=None):
    """
    Grid scattered visibilities onto an NxN complex grid (natural weighting).
    Returns (grid_complex, weight_grid_real, uv_max).
    """
    if uv_max is None:
        uv_max = max(np.abs(u).max(), np.abs(v).max(), 1.0) * 1.05
    # Place the DC cell at index N//2 (matches np.fft.fftshift), so the
    # Hermitian-conjugate pair (-u,-v) lands symmetric about the FFT center.
    ui = np.floor((u / uv_max + 1.0) * 0.5 * N).astype(int)
    vi = np.floor((v / uv_max + 1.0) * 0.5 * N).astype(int)
    np.clip(ui, 0, N - 1, out=ui)
    np.clip(vi, 0, N - 1, out=vi)
    grid = np.zeros((N, N), dtype=np.complex128)
    wt   = np.zeros((N, N), dtype=np.float64)
    np.add.at(grid, (vi, ui), vis)
    np.add.at(wt,   (vi, ui), 1.0)
    m = wt > 0
    grid[m] /= wt[m]
    return grid, wt, uv_max


def _ifft_image(grid):
    """Centred 2-D IFFT returning a real image (taking the real part)."""
    img = np.fft.ifftshift(np.fft.ifft2(np.fft.fftshift(grid)))
    return img.real


# ── clean-beam fitting ──────────────────────────────────────────────────────
def _gaussian_2d(N, sx, sy, theta=0.0, x0=None, y0=None):
    """
    Evaluate a normalised 2-D Gaussian on an NxN grid.
    sx, sy: stddev in pixels along the Gaussian principal axes.
    theta: rotation in radians.
    """
    if x0 is None: x0 = N / 2.0
    if y0 is None: y0 = N / 2.0
    y, x = np.mgrid[0:N, 0:N].astype(np.float64)
    xr = (x - x0) * np.cos(theta) + (y - y0) * np.sin(theta)
    yr = -(x - x0) * np.sin(theta) + (y - y0) * np.cos(theta)
    return np.exp(-0.5 * ((xr / sx) ** 2 + (yr / sy) ** 2))


def _fit_psf_gaussian(psf, fit_box=11):
    """
    Fit a circular Gaussian to the PSF main lobe by least-squares around its peak.
    Returns sigma in pixels (single value — circular beam is fine for our 6-baseline
    array; a full elliptical fit would require fitting 5 parameters which is overkill).

    Algorithm:  use the second-moment of |PSF| above half-max within `fit_box`
    pixels of the peak. This is robust and dependency-free.
    """
    N = psf.shape[0]
    cy, cx = np.unravel_index(np.argmax(np.abs(psf)), psf.shape)
    half = fit_box // 2
    y0, y1 = max(0, cy - half), min(N, cy + half + 1)
    x0, x1 = max(0, cx - half), min(N, cx + half + 1)
    sub = psf[y0:y1, x0:x1].astype(np.float64)
    sub = np.maximum(sub, 0.0)            # ignore negative sidelobes
    peak = sub.max()
    if peak <= 0:
        return 1.0
    mask = sub > 0.5 * peak
    if mask.sum() < 4:
        return 1.0
    yy, xx = np.indices(sub.shape)
    yy = yy - (cy - y0)
    xx = xx - (cx - x0)
    w = sub[mask]
    r2 = (xx[mask] ** 2 + yy[mask] ** 2).astype(np.float64)
    # Fit  w = peak * exp(-r^2 / (2 sigma^2))
    # ln(w/peak) = -r^2 / (2 sigma^2)
    lhs = np.log(w / peak)
    valid = lhs < -1e-6
    if valid.sum() < 3:
        return 1.0
    sigma2 = -0.5 * (r2[valid] * lhs[valid]).sum() / (lhs[valid] ** 2).sum()
    sigma = np.sqrt(max(sigma2, 0.25))
    return float(sigma)


# ── core CLEAN loop ──────────────────────────────────────────────────────────
def hogbom_clean(dirty, psf, gain=0.1, threshold=0.01, max_iter=1000):
    """
    Hogbom CLEAN.

    Parameters
    ----------
    dirty : (N, N) real array     dirty image
    psf   : (N, N) real array     dirty beam, peak normalised to 1, centred at (N/2, N/2)
    gain  : float in (0, 1]       loop gain (fraction of peak subtracted per iter)
    threshold : float             stop when |peak| < threshold * initial_peak
    max_iter  : int               iteration cap

    Returns
    -------
    components : (N, N) array     delta-function model (unrestored)
    residual   : (N, N) array     dirty image after subtraction
    n_iter     : int              iterations actually performed
    """
    N = dirty.shape[0]
    residual = dirty.astype(np.float64).copy()
    components = np.zeros_like(residual)

    psf_max = np.abs(psf).max()
    if psf_max <= 0:
        return components, residual, 0
    psf_n = psf.astype(np.float64) / psf_max  # normalise PSF peak to 1

    # PSF assumed centred at (N//2, N//2).
    psf_cy, psf_cx = N // 2, N // 2

    initial_peak = np.abs(residual).max()
    if initial_peak <= 0:
        return components, residual, 0
    stop_level = threshold * initial_peak

    for it in range(max_iter):
        # find peak of |residual|
        idx = np.argmax(np.abs(residual))
        py, px = np.unravel_index(idx, residual.shape)
        peak_val = residual[py, px]
        if abs(peak_val) < stop_level:
            return components, residual, it

        amp = gain * peak_val
        components[py, px] += amp

        # Subtract gain·peak·shifted PSF using a **circular** shift.
        # The dirty image is produced by FFT-based gridding which is a
        # periodic (circular) convolution, so subtracting a clipped PSF
        # leaves the wrap-around aliases of each source's sidelobes in
        # the residual; those accumulate into a diagonal grating and can
        # cause the residual to grow instead of shrink. Using np.roll
        # properly inverts the circular convolution.
        shift_y = py - psf_cy
        shift_x = px - psf_cx
        residual -= amp * np.roll(psf_n, (shift_y, shift_x), axis=(0, 1))

    return components, residual, max_iter


def _restore(components, residual, beam_sigma_pix):
    """
    Convolve the component model with a Gaussian "clean beam" (FFT-based)
    and add the residual back in.  Returns the restored image.
    """
    N = components.shape[0]
    beam = _gaussian_2d(N, beam_sigma_pix, beam_sigma_pix)
    # FFT convolution (periodic; PSF is small so wrap-around is negligible).
    F_b = np.fft.fft2(np.fft.ifftshift(beam))
    F_c = np.fft.fft2(components)
    cln = np.real(np.fft.ifft2(F_c * F_b))
    return cln + residual


# ── high-level pipeline ──────────────────────────────────────────────────────
def run_clean(u, v, amp, phase, N, gain=0.1, threshold=0.01, max_iter=1000):
    """
    Full CLEAN pipeline from scattered UV samples to restored image.

    Returns dict with keys:
        clean_image      : (N, N) restored CLEAN image  (real)
        dirty_image      : (N, N) dirty image           (real)
        psf              : (N, N) dirty beam            (real)
        residual         : (N, N) residual after CLEAN  (real)
        components       : (N, N) sparse component map  (real)
        n_iter           : int   actual iterations
        beam_sigma_pix   : float fitted clean-beam sigma in pixels
        beam_fwhm_pix    : float clean-beam FWHM in pixels
        peak_dirty       : float peak of dirty image
        peak_residual    : float peak of residual
        dynamic_range    : float peak_dirty / std(residual)
        lm_extent        : float half-extent of image in direction-cosine units
        elapsed_s        : float wall-clock time
    """
    t0 = time.time()
    vis = amp.astype(np.complex128) * np.exp(1j * phase.astype(np.float64))

    # --- visibility grid → dirty image ---
    vis_grid, _wt, uv_max = _grid_uv(u, v, vis, N)
    dirty_img = _ifft_image(vis_grid)

    # --- unit-amplitude grid → PSF (dirty beam) ---
    # Use the same gridding so PSF matches the dirty image's sampling function.
    unit = np.ones_like(vis)
    psf_grid, _wt2, _ = _grid_uv(u, v, unit, N, uv_max=uv_max)
    psf_img = _ifft_image(psf_grid)

    # PSF is real-valued and peaked at the image centre. Normalise to unit peak.
    psf_peak = np.abs(psf_img).max()
    if psf_peak > 0:
        psf_img = psf_img / psf_peak

    # --- Hogbom CLEAN ---
    components, residual, n_iter = hogbom_clean(
        dirty_img, psf_img, gain=gain, threshold=threshold, max_iter=max_iter
    )

    # --- fit clean beam, restore ---
    beam_sigma = _fit_psf_gaussian(psf_img)
    clean_img = _restore(components, residual, beam_sigma)

    fwhm = 2.3548 * beam_sigma
    dl = 1.0 / (2.0 * uv_max)              # cell size in direction cosine
    lm_extent = dl * N / 2.0

    res_std = float(np.std(residual)) if residual.size else 0.0
    peak_d = float(np.abs(dirty_img).max())
    dr = peak_d / res_std if res_std > 1e-30 else 0.0

    return {
        "clean_image":   clean_img.astype(np.float32),
        "dirty_image":   dirty_img.astype(np.float32),
        "psf":           psf_img.astype(np.float32),
        "residual":      residual.astype(np.float32),
        "components":    components.astype(np.float32),
        "n_iter":        int(n_iter),
        "beam_sigma_pix": float(beam_sigma),
        "beam_fwhm_pix":  float(fwhm),
        "peak_dirty":     peak_d,
        "peak_residual":  float(np.abs(residual).max()),
        "dynamic_range":  float(dr),
        "lm_extent":      float(lm_extent),
        "elapsed_s":      float(time.time() - t0),
    }
