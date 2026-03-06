import numpy as np
import matplotlib.pyplot as plt

#Function: Convert linear to dB value 
def db_mag(x, eps=1e-12):
    x = np.asarray(x)
    return 20*np.log10(np.abs(x) + eps)

def db_pwr(x, eps=1e-12):
    x = np.asarray(x)
    return 10*np.log10(np.abs(x)**2 + eps)


#Function: Generate the input to coeficients
def generate_win_coeffs_np(M: int, P: int, window: str = "hamming", normalize: bool = True):
    
    #Generate prototype FIR taps length L=M*P using windowed-sinc.

    #M = taps per branch (taps per bin)
    #P = number of branches (FFT size / number of channels)
    
    L = M * P
    n = np.arange(L, dtype=np.float64)
    n0 = (L - 1) / 2.0
    t = n - n0

    #Window
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

    # Normalize overall gain (common choice)
    if normalize:
        h /= np.sum(h)

    return h
 
#plot taps in time domain
def plot_prototype_taps(h, title="Prototype taps h[n]"):
    h = np.asarray(h)
    n = np.arange(h.size)

    plt.figure()
    plt.plot(n, h)
    plt.title(title)
    plt.xlabel("n (tap index)")
    plt.ylabel("h[n]")
    plt.grid(True)
    plt.show()

#plot frequency response (magnitude dB)
def plot_frequency_response(h, nfft=65536, title="Prototype frequency response |H(f)|"):
    h = np.asarray(h)
    H = np.fft.fftshift(np.fft.fft(h, n=nfft))
    f = np.fft.fftshift(np.fft.fftfreq(nfft, d=1.0))  # cycles/sample

    mag = np.abs(H)
    mag_db = 20*np.log10(mag / (mag.max() + 1e-15) + 1e-15)

    plt.figure()
    plt.plot(f, mag_db)
    plt.title(title)
    plt.xlabel("Normalized frequency (cycles/sample)")
    plt.ylabel("Magnitude (dB, normalized)")
    plt.ylim(-140, 5)
    plt.grid(True)
    plt.show()


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

    if do_plot:
        plot_prototype_taps(h, title=f"Prototype taps (M={M}, P={P}, window={window})")
        plot_frequency_response(h, title=f"Prototype response (M={M}, P={P}, window={window})")

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


#FAKE DATA bellow
def fake_multitone_iq(N, P, bins=(100, 250.5), amps=(1.0, 0.6), noise_std=0.02, seed=0):
    rng = np.random.default_rng(seed)
    n = np.arange(N)
    x = np.zeros(N, dtype=complex)

    for b, a in zip(bins, amps):
        f = b / P
        x += a * np.exp(1j * 2*np.pi * f * n)

    if noise_std > 0:
        x += noise_std * (rng.standard_normal(N) + 1j*rng.standard_normal(N))
    return x

def fake_4ch_iq(N, P, bins=(100,), amps=(1.0,), noise_std=0.02,
               delays=(0, 2, 5, 9), phases_deg=(0, 30, 90, 150), seed=0):
    base = fake_multitone_iq(N + max(delays), P, bins=bins, amps=amps, noise_std=0.0, seed=seed)
    rng = np.random.default_rng(seed + 1)

    x4 = np.zeros((4, N), dtype=complex)
    for ch in range(4):
        d = int(delays[ch])
        ph = np.deg2rad(phases_deg[ch])
        sig = base[d:d+N] * np.exp(1j * ph)
        sig += noise_std * (rng.standard_normal(N) + 1j*rng.standard_normal(N))
        x4[ch] = sig
    return x4


#Main 
if __name__ == "__main__":
    P = 1024
    M = 4
    N = P * 200

    # 1-channel test
    x = fake_multitone_iq(N, P, bins=(100, 250.5), amps=(1.0, 0.6), noise_std=0.01)
    X, h = pfb_channelize_np(x, M, P, window="hamming", do_plot=True)
    plot_channel_power(X, title="1-ch avg channel power")

    # 4-channel test
    x4 = fake_4ch_iq(N, P, bins=(100,), amps=(1.0,), delays=(0, 1, 3, 6), phases_deg=(0, 20, 70, 140), noise_std=0.01)
    X4, h = pfb_channelize_multich_np(x4, M=M, P=P)
    print("X4 shape:", X4.shape)  # (4, frames, P)

"""
Store the data from lates frame
Threading data

Need to fix: Forntend, channekized de compine dc vs fmcomms5_iio, va main 


"""