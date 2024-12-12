
# Time-Frequency Analysis with Fourier and Wavelet Transforms

This repository contains MATLAB code for a practical session on time-frequency analysis. The main focus is to study the spectral content of non-stationary signals using techniques such as the **Sliding Window Fourier Transform**, the **Gabor Transform**, and the **Continuous Wavelet Transform (CWT)**. This README explains the theoretical background and the step-by-step implementation of each method.

---

We analyze the signals provided in `.mat` files:

-  **Piano Signal (`SigPiano.mat`)**
   A \~2-second excerpt from a piano piece to identify the sequence of notes played.
<p align="center">
<img width="500" height="400" src="https://github.com/user-attachments/assets/a4da53d9-25cb-4ed1-9a12-58649469cfd6" alt="my banner">
</p>


---

## Why not classic Fourier Transform ?

Classic Fourier Transform gives a theoretical infinite precision in frequency, but completely overpass the temporal characteristics of the signal. For instance for a sinusoidal signal the FT will be suited, but for a simple chirp $s(t) = \cos(2 \pi f(t) t)$ signal FT is unable to highlight the temporal variation of the instantaneous frequency $f(t)$ of the signal.

<div style="display: flex; justify-content: center; gap: 20px;">
    <img width="500" height="400" src="https://github.com/user-attachments/assets/3cbd44b6-fedb-4061-92ae-b5f9b1106c4e" alt="Image 1">
    <img width="500" height="400" src="https://github.com/user-attachments/assets/d61a27ab-0f83-4146-a421-64c955dc4e37" alt="Image 2">
</div>

In the case of a non-stationary signal, the autocorrelation function depends on time. The power spectral density (PSD) no longer allows us to understand the signal's content, so we must perform a time-frequency analysis. One solution to estimate the spectral content of the signal around a time t0 is to calculate the periodogram over a small number of points.

## Heisenberg inequality

The Heisenberg uncertainty principle in signal processing reveals a fundamental trade-off: the more precisely we localize a signal in time, the less precisely we can determine its frequency content.

$$\sigma_{\omega}^{2} \sigma_{t}^{2} \geq \frac{1}{2}$$
This principle will be highlighted in the following experiments
## Short-Time Fourier Transform (STFT)

Let $x_n$ be a signal measured for $n \in\{1, \cdots, N\}$, to obtain a time and frequency localized decomposition, we will perform a Fourier transform on an interval composed of a small number $K$ of samples $(K<N)$ centered at $x_{n_0}$. The sliding window Fourier transform of $x$, $STFT\left(n_0, \nu\right)$ is written as:

$$
STFT\left(n_0, \nu\right)=\frac{1}{K}\left|\sum_{k=1}^K x_{\left\[n_0-K / 2+k\right]} e^{-2 j \pi \nu k}\right|^2
$$

**Remark 1:** This transform assumes that the signal is stationary over the small interval, which is not necessarily verified.

**Remark 2:** If the number of samples $K$ in the interval decreases, the frequency resolution decreases. Similarly, if the number of samples $K$ increases, the temporal resolution decreases. Heisenberg demonstrated that when performing a time-frequency analysis, the product of temporal dispersion and spectral (frequency) dispersion is bounded. Consequently, it is impossible to be simultaneously infinitely precise in time and frequency, a property that holds regardless of the number of measurements available.

**Remark 3:** The sliding window Fourier transform is not the time-frequency transform with the best compromise between temporal resolution and frequency resolution; it does not reach the Heisenberg inequality bound.

#### Algorithm

- We cut the signal composed of $N$ points into $P$ signals of $K$ points using the `decoupe.m` function. The result is stored in a `MatSig` matrix of size $K × P.$
- We now apply a 1D Fourier transform to each of the $P$ signals. For this, you can use the command `fft(MatSig,M)` which returns a sequence of $P$ Fourier transforms on $M$ points (that is, a matrix of size $M × P$).
- Take the module of the matrix and square it to calculate the periodogram associated with each column.

<p align="center">
<img width="500" height="400" src="https://github.com/user-attachments/assets/28018c6b-6ae6-4d7e-bbba-c774959b6022" alt="my banner">
</p>

## Gabor Transform

In 1946, Dennis Gabor introduced a transformation that reaches the Heisenberg inequality bound. He replaced the rectangular window in the Short-Time Fourier Transform with a Gaussian window. Let G(n0, ν) denote the Gabor transform.

$$G(n_0, \nu) = \sum_{n \in \mathbb{Z}} x_n e^{-\frac{(n-n_0)^2}{4\sigma_t^2}} e^{-2j\pi\nu n}$$

where $\sigma_t$ is the full width at half maximum of the Gaussian. We will write the algorithm to calculate the Gabor transform of a signal.

### Algorithm

- Calculate the truncated Gaussian window using the `FenetreApodisation.m` function.
- Cut the signal composed of $N$ points into $P$ signals of $K$ points using the `Decoupe.m` function (use `help Decoupe` to understand its operation). The result is stored in a matrix `MatSig` of size $K \times P$.
- Multiply the $P$ signals by the truncated Gaussian window (in the equation above, multiplication of $x_n$ by $e^{-\frac{\left(n-n_0\right)^2}{4 \sigma_t^2}}$).
- Finally, apply a 1D Fourier transform simultaneously on each of the $P$ signals using the command `fft(MatSig, M)`. The result is stored in a matrix that can be called `specgm` of size $M \times P$.


<p align="center">
<img width="500" height="400" src="https://github.com/user-attachments/assets/30311fef-25ef-426d-a10f-836281ec9ce1" alt="my banner">
</p>
The Gabor does not clearly appear better than STFT and may even be less precise in frequence, but conversely to STFT this transform reaches the Heisenberg bound, so if precision in frequency domain (caraterized by $\sigma_\omega$) is lower than for Gabor Transform it is because precision in time domain is better ($\sigma_t$).

### Inverse Gabor Transform

The Gabor transform is not an orthogonal transform, so the information in the spectrogram is redundant. We must account for this redundancy when implementing the transformation's inversion. The inversion of the Gabor transform is :

$$
g\left(n_0, k\right)=\sum_{l=1}^N G\left(n_0, \nu_l\right) e^{2 j \pi \nu_l k}=x_k e^{-\frac{\left(k-n_0\right)^2}{4 \sigma_t^2}}
$$

We can then deduce:

$$
x_k=\frac{\sum_{p=1}^P g\left(n_p, k\right)}{\sum_{p=1}^P e^{-\frac{\left(k-n_p\right)^2}{4 \sigma_t^2}}}
$$
<p align="center">
<img width="500" height="400" src="https://github.com/user-attachments/assets/30311fef-25ef-426d-a10f-836281ec9ce1" alt="my banner">
</p>
The signal has been reconstructed for different window sizes. Here we clearly see the precision in time : when increasing the window length (parameter `LongFen`) the frequency precision $\sigma_\omega$ is increased, but the time precison $\sigma_t$ decreases as we can see the reconstruction error increases.

### Algorithm

- Calculate the truncated Gaussian window `filtreApo` using the `FenetreApodisation.m` function.
- Apply an inverse Fourier transform to each of the $P$ columns of the spectrogram. This can be done using the `ifft(specgm)` command, which returns a sequence of $P$ signals over $N$ points (a matrix of size $N \times P$).
- Calculate the $x_k$ values using equation (5).
- Test your algorithm on a synthetic signal to validate it.

## Continuous Wavelet Transform

The wavelet transform is a powerful signal processing technique that provides a multi-resolution analysis, allowing for adaptive time-frequency representation. Unlike traditional Fourier transforms that use fixed-width windows, wavelets use scaled and translated basis functions that can zoom in or out on different parts of a signal. This approach enables superior analysis of non-stationary signals by offering variable resolution: high time resolution for high-frequency components and high frequency resolution for low-frequency components. The transform is defined by :


$$
W_\psi f((a,b))=\left\langle f, \psi{(a,b)}\right\rangle=\left\[ f \star \bar{\psi}_a\right ](b)
$$

Where:

$$
\psi{(a,b)}(t)=|a|^{-\frac{1}{2}} \psi\left(\frac{t-b}{a}\right) \quad \text{ where } (a, b) \in \mathbb{R}^* \times \mathbb{R}
$$

And $\bar{\psi}{(a,b)}=\psi{(a,-b)}$

The method is particularly effective for signals with sudden changes, transient phenomena, or complex temporal dynamics, making it invaluable in fields such as image compression, noise reduction, geophysical signal analysis, and biomedical signal processing. By breaking down signals into different scales and positions, wavelets capture local time-frequency characteristics that traditional transforms miss, providing a more nuanced and flexible view of signal behavior.

The Wavelet transform has been computed calling the `FWT_PO` and `MakeONFilter` functions.

Just as with the inverse Gabor Transform, the signal can be reconstructed from wavelet coefficient using inverse transform

<p align="center">
<img width="500" height="400" src="https://github.com/user-attachments/assets/7af2ff5e-c8dc-4d2a-8fff-c5b948a8c9a6" alt="my banner">
</p>

Here the reconstructed signal is close to the original one but the trade-off on frequency precision is better. More precisely the reconstructed signal keep both low and high frequency thanks to the change of scale of the wavelet transform. 
