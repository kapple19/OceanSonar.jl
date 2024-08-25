# Detection Threshold

The detection threshold ``\DT`` as a function of detection index ``d`` is given by

```math
\DT = -5\log_{10}(d)
```

where

```math
d = 2\calE/N_0
```

## Abraham Info Box pg 84-5

* Deterministic signal with CMF: Equation 2.95
  * Noise: ``\calN(0, 1)``
  * SPN: ``\calN(\sqrt{2 S^\rmd}, 1)``
* Deterministic signal with integrated QMF or ED:
  * Exact for ``M \geq 1``: Sec 7.5.1 or 8.8.2

## Kaw: Derivation

1. ``h(P_f)``
2. ``h(\SNR)``
3. ``h(P_d)``

Theoretical:

1. ``N \sim\ ?``, ``S \sim\ ?``
2. ``T`` (optimal)
3. ``X_0 \sim\ T(N)``, ``X_1 \sim\ T(S + N)``
4. ``P_f = 1 - F_0(h)``, ``P_d = 1 - F_1(h)``
5. ``h = h \Rightarrow F_0^{-1}(1 - P_f) = F_1^{-1}(1 - P_d)``
6. ``\rmE\{X_0\}, \rmE\{X_1\}, \Var\{X_0\} = \Var\{X_1\}`` w.r.t. distribution parameters
7. Distribution parameters w.r.t. ``(P_f, P_d)``
8. ``\rmE\{X_0\}, \rmE\{X_1\}, \Var\{X_0\} = \Var\{X_1\} \wrt (P_f, P_d)``
9. ``d(\rmE\{X_0\}, \rmE\{X_1\}, \Var\{X_0\}) = d(P_f, P_d)`` by substitution of ``H_1`` mean

## Abraham Eqn 2.95

Conditions:

* Signal known exactly ``\Rightarrow`` CMF optimal.
* Noise: Gaussian.
* Detector: ?

```math
\phi_f = \Phi^{-1}(1 - P_f) \\
\phi_d = \Phi^{-1}(1 - P_d) \\
d = (\phi_f - \phi_d)^2
```

If ``T`` is time over which MSP is formed,
then ``\calE = T P_0^a``
and

```math
d = \frac{2\calE}{N_0} \\
= 2\left( \frac{\calE / T}{N_0 W} \right) \\
= 2 S^a W T \\
= 2 S^d
```

```math
\DT = \overline{\SNR}^d = 10 \log_{10}\left[ \frac{\left( \phi_f - \phi_d \right)^2}{2} \right]
```

## Kaw: Deterministic Signal with CMF

Expectation and variance coincide with parameters.

Goal is easier to reach with abstraction of distribution statistics,
also easier to see relationships:

* ``\mu_N = 0``
* ``\mu_S = ?``
* ``\sigma_0 = 1``
* (``\mu_0 = \mu_N``)
* (``\rmE\{T(S + N)\} = \mu_1 = \sqrt{2 S^\rmd}``)

Assumptions:

```math
\begin{align*}
    N &\sim \calN(\mu_N, \sigma_0) \\
    S &=\ \mu_S
\end{align*}
```

Optimal processor:

```math
T(x) =\ ?
```

Hypotheses:

```math
\begin{align*}
    S + N &\sim \calN(\mu_N + \mu_S, \sigma_0) \\
    X_0 &\sim T(N) \sim \calN(\mu_0, \sigma_0) \\
    X_1 &\sim T(S + N) \sim \calN(\mu_1, \sigma_0)
\end{align*}
```

Probabilities:

```math
\begin{align*}
    P_f &= 1 - F_0(h) = 1 - \Phi\left( \frac{h - \mu_0}{\sigma_0} \right) \\
    P_d &= 1 - F_1(h) = 1 - \Phi\left( \frac{h - \mu_1}{\sigma_0} \right)
\end{align*}
```

Relating probabilities:

```math
\begin{align*}
    h &= \sigma_0 \Phi^{-1}(1 - P_f) + \mu_0 \\
    h &= \sigma_0 \Phi^{-1}(1 - P_d) + \mu_1 \\
    \Rightarrow \sigma_0 \Phi^{-1}(1 - P_f) + \mu_0 &= \sigma_0 \Phi^{-1}(1 - P_d) + \mu_1
\end{align*}
```

Detection index components:

```math
\begin{align*}
    \rmE\{X_1\}(P_f, P_d)
    &= \mu_1 = \mu_0 + \sigma_0 \left[ \Phi^{-1}(1 - P_f) - \Phi^{-1}(1 - P_d) \right]
\end{align*}
```

Detection index:

```math
\begin{align*}
    \sqrt{d} &= \frac{\rmE\{X_1\}(P_f, P_d) - \rmE\{X_0\}(P_f, P_d)}{\STD\{X_0\}(P_f, P_d)} \\
    &= \frac{\mu_1 - \mu_0}{\sigma_0} \\
    &= \frac{
        \mu_0 + \sigma_0 \left[ \Phi^{-1}(1 - P_f) - \Phi^{-1}(1 - P_d) \right] - \mu_0
    }{\sigma_0} \\
    &= \Phi^{-1}(1 - P_f) - \Phi^{-1}(1 - P_d)
\end{align*}
```

## Kaw: Exponential

```math
\begin{align*}
    P_f &= 1 - F_0(h) \\
    &= e^{-h/\lambda_0} \\
    P_d &= e^{-h/\lambda_1}
\end{align*}
```

```math
\begin{align*}
    h &= \lambda_0 \ln(P_f) \\
    h &= \lambda_1 \ln(P_d) \\
    \Rightarrow \lambda_0 \ln(P_f) &= \lambda_1 \ln(P_d)
\end{align*}
```

```math
\begin{align*}
    \rmE\{ X_1 \} &= \lambda_0 \frac{\ln(P_f)}{\ln(P_d)} \\
    \sqrt{d} &= \frac{
        \lambda_0 \dfrac{\ln(P_f)}{\ln(P_d)} - \lambda_0
    }{
        \lambda_0
    } \\
    &= \dfrac{\ln(P_f)}{\ln(P_d)} - 1
\end{align*}
```

## Kaw: Rayleigh

```math
\begin{align*}
    P_f &= e^{-h^2/(2\sigma_0^2)} \\
    P_d &= e^{-h^2/(2\sigma_1^2)} \\
    \sqrt{-2\sigma_0^2\ln(P_f)} &= \sqrt{-2\sigma_1^2\ln(P_d)} \\
    \sigma_1 &= \sqrt{\sigma_0^2 \frac{\ln(P_f)}{\ln(P_d)}} \\
    \rmE\{X_1\} &= \sigma_1\sqrt{\frac{\pi}{2}} \\
    &= \sqrt{\sigma_0^2 \frac{\pi}{2} \frac{\ln(P_f)}{\ln(P_d)}} \\
    \sqrt{d} &= \frac{\rmE\{X_1\} - \rmE\{X_0\}}{\STD\{X_0\}} \\
    &= \frac{
        \sigma_1\sqrt{\pi/2} - \sigma_0\sqrt{\pi/2}
    }{
        \sigma_0 \sqrt{2 - \pi/2}
    } \\
    &= \frac{
        \sqrt{\sigma_0^2 \dfrac{\pi}{2} \dfrac{\ln(P_f)}{\ln(P_d)}} - \sigma_0\sqrt{\pi/2}
    }{
        \sigma_0 \sqrt{2 - \pi/2}
    } \\
    &= \frac{
        \sqrt{\dfrac{\pi}{2} \dfrac{\ln(P_f)}{\ln(P_d)}} - \sqrt{\dfrac{\pi}{2}}
    }{
        \sqrt{2 - \dfrac{\pi}{2}}
    } \\
    &= \sqrt{\frac{\pi}{4 - \pi}} \left( \frac{\ln(P_f)}{\ln(P_d)} - 1 \right)
\end{align*}
```

## Kaw: Rice

Generalised Rayleigh.

```math
\begin{align*}
    X_0 &\sim \Rice(\sigma_0, \alpha_0) \\
    X_1 &\sim \Rice(\sigma_1, \alpha_1) \\
    P_f &= Q_1\left( \frac{\alpha_0}{\sigma_0}, \frac{h}{\sigma_0} \right) \\
    P_f &= Q_1\left( \frac{\alpha_1}{\sigma_1}, \frac{h}{\sigma_1} \right) \\
    h &= \sigma_0 Q_1^{-1}\left( \frac{\alpha_0}{\sigma_0}, P_f \right) \\
    h &= \sigma_1 Q_1^{-1}\left( \frac{\alpha_1}{\sigma_1}, P_d \right) \\
    \sigma_0 Q_1^{-1}\left( \frac{\alpha_0}{\sigma_0}, P_f \right)
    &= \sigma_1 Q_1^{-1}\left( \frac{\alpha_1}{\sigma_1}, P_d \right)
\end{align*}
```

## Kaw: Computation

Theory:

1. ``N \sim\ ?``, ``S \sim\ ?``
2. ``T`` (optimal)
3. ``X_0 \sim\ T(N)``, ``X_1 \sim\ T(S + N)``
4. ``P_f = 1 - F_0(h)``, ``P_d = 1 - F_1(h)``
5. ``h = h \Rightarrow F_0^{-1}(1 - P_f) = F_1^{-1}(1 - P_d)``
6. ``\rmE\{X_0\}, \rmE\{X_1\}, \Var\{X_0\} = \Var\{X_1\}`` w.r.t. distribution parameters
7. Distribution parameters w.r.t. ``(P_f, P_d)``
8. ``\rmE\{X_0\}, \rmE\{X_1\}, \Var\{X_0\} = \Var\{X_1\} \wrt (P_f, P_d)``
9. ``d(\rmE\{X_0\}, \rmE\{X_1\}, \Var\{X_0\}) = d(P_f, P_d)`` by substitution of ``H_1`` mean

Generalisation Implementation:

1. Define noise and signal distributions.
2. Define detector.
3. Derive cumulative distribution functions of hypotheses.
4. Derive inverse CDFs.
5. Express probabilities w.r.t. detector threshold.
6. TODO.
