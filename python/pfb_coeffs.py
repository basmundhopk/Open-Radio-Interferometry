import numpy as np
from settings import M, P, PFB_WINDOW

def generate_win_coeffs_np(M: int = M, P: int = P, window: str = PFB_WINDOW, normalize: bool = True):
    #Generate prototype FIR taps length L=M*P using windowed-sinc.

    #M = taps per branch (taps per bin)
    #P = number of branches (FFT size / number of channels)

    L = M * P
    n = np.arange(L, dtype=np.float64)
    n0 = (L - 1) / 2.0
    t = n - n0

    window = window.lower()

    if window == "hamming":
        w = np.hamming(L)
    elif window in ("hann", "hanning"):
        w = np.hanning(L)
    else:
        raise ValueError("window must be 'hamming' or 'hann'/'hanning'")

    # Ideal lowpass (normalized cutoff ~ 1/P of Nyquist)
    # cycles/sample fc = (1/P)*0.5 = 1/(2P)
    # impulse response: h = 2*fc*sinc(2*fc*(n-n0)) = (1/P)*sinc((n-n0)/P)
    h_ideal = (1.0 / P) * np.sinc(t / P)

    h = w * h_ideal

    if normalize:
        h /= np.sum(h)

    return h