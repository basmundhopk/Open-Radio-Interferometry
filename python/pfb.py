import numpy as np
import matplotlib.pyplot as plt
from pfb_coeffs import generate_win_coeffs_np

# Conversion functions between power types
def db_mag(x, eps=1e-12):
    x = np.asarray(x)
    return 20*np.log10(np.abs(x) + eps)

def db_pwr(x, eps=1e-12):
    x = np.asarray(x)
    return 10*np.log10(np.abs(x)**2 + eps)


#Function:  pfb frontend
def pfb_fir_frontend_np(x, h, M: int, P: int):
    """
    Polyphase FIR front-end.
    x: 1D complex (or real) samples
    h: prototype taps length M*P
    Returns y: shape (n_frames, P)  # "subfiltered branches" y_p(n')
    """
    x = np.asanyarray(x)
    h = np.asanyarray(h)

    L = M * P
    if h.size != L:
        raise ValueError(f"h must have length M*P = {L}, got {h.size}")
    # Split input into blocks of P samples (time index n')
    B = x.size // P
    x = x[:B * P]
    x_blocks = x.reshape(B, P).T          # shape (P, B)  => x_p[p, n']
    h_poly   = h.reshape(M, P).T          # shape (P, M)  => h_p[p, m]

    n_frames = B - M + 1
    if n_frames <= 0:
        raise ValueError("Not enough data: need at least M blocks of P samples.")

    y = np.zeros((n_frames, P), dtype=np.complex128)

    # Implements: y_p[n'] = sum_{m=0..M-1} h_p[m] * x_p[n'+m] (forward form)
    # Equivalent to textbook x_p[n'-m] with reversed tap indexing.
    for t in range(n_frames):
        seg = x_blocks[:, t:t+M]          # (P, M)
        y[t, :] = np.sum(seg * h_poly, axis=1)

    return y


#Function: PFB channelizer
def pfb_channelize_np(x, M: int, P: int, window="hamming", fftshift=False, do_plot=False):
    h = generate_win_coeffs_np(M, P, window=window, normalize=True)

    y = pfb_fir_frontend_np(x, h, M, P)
    X = np.fft.fft(y, axis=1)

    if fftshift:
        X = np.fft.fftshift(X, axes=1)

    return X, h

#Plot the channelized output
def plot_channel_power(X, title="Average channel power"):
    # X shape: (frames, P)
    pwr = np.mean(np.abs(X)**2, axis=0)
    plt.figure()
    plt.plot(pwr)
    plt.title(title)
    plt.xlabel("Bin k")
    plt.ylabel("Power")
    plt.grid(True)
    plt.show()


#4 simultaneous coherent RX stream
def pfb_channelize_multich_np(x4, M: int = 4, P: int = 1024, window="hamming", fftshift=False, h=None):
    """
    x4: array of samples from 4 channels.
        Accepts shape (4, N) or (N, 4). Real or complex.
    Returns:
        X: shape (4, n_frames, P)
        h: prototype taps length M*P
    """
    x4 = np.asarray(x4)

    # normalize shape to (4, N)
    if x4.ndim != 2:
        raise ValueError("x4 must be 2D (4,N) or (N,4)")

    if x4.shape[0] == 4:
        pass             # already (4, N)
    elif x4.shape[1] == 4:
        x4 = x4.T         # convert (N, 4) -> (4, N)
    else:
        raise ValueError("x4 must have 4 channels on one axis")
    if h is None:
        h = generate_win_coeffs_np(M, P, window=window, normalize=True)

    X_all = []
    for ch in range(4):
        y = pfb_fir_frontend_np(x4[ch], h, M, P)
        X = np.fft.fft(y, axis=1)
        if fftshift:
            X = np.fft.fftshift(X, axes=1)
        X_all.append(X)

    return np.stack(X_all, axis=0), h   # (4, frames, P)