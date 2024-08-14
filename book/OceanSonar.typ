#import "@preview/jlyfish:0.1.0": *

#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")

#read-julia-output(json("OceanSonar-jlyfish.json"))
#jl-pkg(
  "CairoMakie",
  "Distributions",
  "Typstry"
)

= Ocean Sonar
== Sonar Oceanography
== Ocean Acoustics
== Sonar Signal Processing

== Statistical Detection Theory

=== Probability Metrics

The vector of received acoustic data is modelled as $arrow(x)$. The two possibilities to be discerned upon receiving acoustic data are:

- Noise only
- Signal present in the noise

The hypothesis that the acoustic data contains only noise is labelled $H_0$, and the hypothesis that the acoustic data contains a signal with the noise is labelled $H_1$.

The distributions of the acoustic data under the noise-only hypothesis $X_0 = T(arrow(n))$ and the signal-present hypothesis $X_1 = T(arrow(s) + arrow(n))$ depend on your noise $arrow(n)$ and signal $arrow(s)$ distributions and the choice of data processor $T$ for enhancing the signal-to-noise ratio.

The probability of false alarm $P_f$ is the metric for an incorrect decision that a signal is present when the true scenario is that the signal is absent. It is thus defined as

$
P_f = upright(Pr){X_0 >= h | H_0}
$

Similarly, the probability of detection $P_d$ is the metric for a correct decision that a signal is present. It is defined as

$
P_f = upright(Pr){X_1 >= h | H_1}
$

The threshold value $h$ is termed the _detector threshold_, to be distinguished from the detection threshold.

The values of both probabilities need to be under consideration when making a decision as to the presence of a signal.

==== Gaussian Noise with Gaussian Signal

The following assumptions are made:

- Noise is white, bandpass, wide-sense-stationary, ergodic, Gaussian.
- Noise spectral density is $N_0$ for $|f| in (f_c - W/2, f_c + W/2)$, $0$ elsewhere.
- $arrow(n) tilde cal(C)cal(N)(arrow(0), lambda_0 arrow(I))$.
- Signal is deterministic: $arrow(s) = ?$

When the signal is known exactly and the noise is Gaussian, a coherent matched filter (CMF) is the optimal processor.

$
T(arrow(x)) = Re(arrow(s)^H arrow(X))
$

This results in Gaussia-distributed detector decision statistics.

$
arrow(s) + arrow(n) &tilde cal(N)(mu_N + mu_S, sigma_N) \
X_0 = T(arrow(n)) &tilde cal(N)(mu_0, sigma_0) \
X_1 = T(arrow(s) + arrow(n)) &tilde cal(N)(mu_1, sigma_1)
$

with

$
mu_0 = T(mu_N)
mu_1 = T(mu_S + mu_N)
$

Probability metrics are

$
P_f &= 1 - F_0(h) = 1 - Phi((h - mu_0) / sigma_0) \
P_d &= 1 - F_1(h) = 1 - Phi((h - mu_1) / sigma_0)
$

#jl(recompute: false, code: true,
```
using Distributions, CairoMakie

X0dist = Normal(0, 1)
X1dist = Normal(1, 1)
X = range(-3, 4, 301)
X0prob = pdf.(X0dist, X)
X1prob = pdf.(X1dist, X)

fig = Figure()
axis = Axis(fig[1, 1])

lines!(axis, X, X0prob)
lines!(axis, X, X1prob)

fig
```
)
