"""Smoke test for the polyphase filter bank prototype generator."""

import numpy as np

from open_radio_interferometry.dsp.pfb import generate_win_coeffs_np


def test_window_length_matches_pfb_size():
    P, M = 1024, 4
    win = generate_win_coeffs_np(P, M, "blackman-harris")
    assert win.shape == (P * M,)
    assert np.isfinite(win).all()


def test_supported_windows():
    for name in ("blackman-harris", "hamming", "hann", "kaiser"):
        win = generate_win_coeffs_np(256, 4, name)
        assert win.shape == (1024,)
        assert win.max() > 0
