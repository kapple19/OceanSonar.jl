#import "@preview/unify:0.6.0": unit
#import "@preview/jlyfish:0.1.0": *

#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")

#show heading.where(level: 1): it => {pagebreak(weak: false);it}
#show heading.where(level: 2): it => {pagebreak(weak: false);it}

#read-julia-output(json("OceanSonar-jlyfish.json"))
#jl-pkg(
  "AbstractTrees",
  "CairoMakie",
  "Distributions",
  "InteractiveUtils",
  "Typstry"
)

#align(center, text(17pt)[Ocean Sonar])

#outline(depth: 2, indent: auto)

#pagebreak()

== Pillars of Ocean Sonar

== Mathematical Preliminaries

=== Special Functions

==== Error Function and Variations

==== Standard Normal Cumulative Distribution Function

== Programming Preliminaries

= Sonar Oceanography

= Ocean Acoustics

= Sonar Signal Processing

== Sonar Scenarios

#jl(recompute: false, code: true,
```
using AbstractTrees: print_tree
using InteractiveUtils: subtypes

import AbstractTrees: children

abstract type SonarType end

abstract type Passive <: SonarType end
abstract type Active <: SonarType end

abstract type Narrowband <: Passive end
abstract type Broadband <: Passive end
abstract type Intercept <: Passive end

children(::Type{T}) where T <: SonarType = subtypes(T)

print_tree(SonarType)
```
)

= Statistical Detection Theory

== Probability Metrics

The collection of received acoustic data is modelled in a vector as $arrow(x)$.
The units of such data may be in #unit("uPa") for amplitude data,
or #unit("uPa^2") for energy data.
(TODO: verify this.)

The objective is to determine if the acoustic data contains noise only, or has a signal present.
We define hypotheses:

- $H_0$: Noise only
- $H_1$: Signal present

The noise data $arrow(n)$ and signal data $arrow(s)$ are assumed to combine additively to form the acoustic data.
That is, under each hypothesis:

$
H_0 &: arrow(x)_0 = arrow(n) \
H_1 &: arrow(x)_1 = arrow(n) + arrow(s)
$

The _detector operator_ $T$ acts on the acoustic data
to reduce the dimension of the data to a scalar
for comparison to a threshold value $h$ termed the _detector threshold_.
The transformed data is termed the _detector statistic_.
Under each hypothesis, the transformed data $X_0$ and $X_1$ are defined:

$
H_0 &: X_0 = T(arrow(x)_0) = T(arrow(n)) \
H_1 &: X_1 = T(arrow(x)_1) = T(arrow(n) + arrow(s))
$

The acoustic data $arrow(x)$ is modelled as having a distribution dependent on the noise and signal distributions.
Upon assuming a distribution for the signal and noise,
the distribution of the transformed data $X_0$ and $X_1$ can be inferred.

The probability metrics of interest for applied detection theory
are the probabilities of false alarm $P_f$ and detection $P_d$, defined:

$
P_f = upright(Pr){X_0 >= h | H_0} \
P_d = upright(Pr){X_1 >= h | H_1}
$

That is, the $P_f$ is the probability of a false positive,
and $P_d$ is the probability of a true positive.
The values of both probabilities need to be under consideration when making a decision as to the presence of a signal.

More generally, the probability metrics above can be expressed in terms of the cumulative distribution function $F_i$ for their respective hypotheses distributions $H_i$ for $i = 0, 1$:

$
H_0: P_f = 1 - F_0(h) \
H_1: P_d = 1 - F_1(h)
$

In some special cases, the mathematical formulae for the detector statistics can be derived theoretically.
In general, this is not possible.
Literature approaches such a limitation either by approximations
or by Monte Carlo simulations.
Some theoretical results are complicated enough to also motivate approximations for particular conditions.
Theoretical derivations, approximations, and Monte Carlo simulations are explored in the following sub-sections.

=== Gaussian Noise with Deterministic Signal <prob_gaussian_deterministic>

The following assumptions are made:

- The noise is white, meaning TODO.
- The noise is bandpass, meaning TODO.
- The noise is wide-sense-stationary ergodic, meaning TODO.
- The noise is Gaussian-distributed, i.e. $arrow(n) tilde cal("CN")(arrow(0), lambda_0 arrow(I))$.
- The noise spectral density is $N_0$ for $|f| in (f_c - W/2, f_c + W/2)$, $0$ elsewhere.
- The signal is deterministic: $arrow(s) = ?$

Under such conditions, a theoretical result is tractable.

When the signal is known exactly and the noise is Gaussian,
a coherent matched filter (CMF) is the optimal processor.
The CMF detector operator is defined as

$
T(arrow(x)) = Re(arrow(s)^H arrow(X))
$

This results in Gaussian-distributed detector decision statistics.

$
arrow(s) + arrow(n) &tilde cal("CN")(?, ?) \
X_0 = T(arrow(n)) &tilde cal(N)(mu_0, sigma_0) \
X_1 = T(arrow(s) + arrow(n)) &tilde cal(N)(mu_1, sigma_0)
$

with

$
mu_0 = ? \
mu_1 = ? \
sigma_0 = ?
$

where we note that the standard deviation of the noise and signal-plus-noise are equivalent.

Probability metrics are

$
P_f &= 1 - F_0(h) = 1 - Phi((h - mu_0) / sigma_0) \
P_d &= 1 - F_1(h) = 1 - Phi((h - mu_1) / sigma_0)
$ <eqn_prob_gaussian_determinstic>

where $Phi$ is the standard normal CDF, defined here as TODO.

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

=== Gaussian Noise with Gaussian Signal

The same assumptions are made here as in @prob_gaussian_deterministic,
bar the signal distribution:

- The signal is fluctuating: $arrow(s) tilde cal("CN")(?, ?)$

Under such conditions, a theoretical result is tractable as in @prob_gaussian_deterministic,
with the addition of a fluctuating index $upright("FI")$ defined:

$
upright("FI") = sigma_1 / sigma_0
$

where $sigma_i$ are the standard deviations of the detector statistics $X_i$ for hypotheses $H_i$, $i = 0, 1$.

== Detection Index and Receiver Operating Characteristic Curves

The _detection index_ $d$ is a measure of detectability.
A higher value implies an easier true positive over false positive detection.

By definition:

$
d = ((upright(E)(X_1) - upright(E)(X_0)))^2 / (upright("Var")(X_0))
$

The _receiver operating characteristic_ (ROC) curves are contour plots of $d$ or sometimes $10log_(10)(d)$ with respect to the probabilities of false alarm $P_f$ and detection $P_d$.

=== Gaussian Noise with Deterministic Signal

Manipulating @eqn_prob_gaussian_determinstic to make the detector threshold $h$ the subject:

$
h = mu_0 + sigma_0 Phi^(-1)(1 - P_f) \
h = mu_1 + sigma_0 Phi^(-1)(1 - P_d)
$

then equating, yields

$
(mu_1 - mu_0) / sigma_0 = Phi^(-1)(1 - P_d) - Phi^(-1)(1 - P_f)
$

Noting that

$
upright(E)(X_0) = mu_0 \
upright(E)(X_1) = mu_1 \
upright("Var")(X_0) = sigma_0
$

we then have

$
sqrt(d) = Phi^(-1)(1 - P_d) - Phi^(-1)(1 - P_f)
$

#jl(recompute: false, code: true,
```
using Distributions, CairoMakie

N = Normal(0, 1)

Pf = range(10^-4, 10^-1, 301)
Pd = range(0.2, 0.9, 201)
d = @. (quantile(N, 1 - Pd') - quantile(N, 1 - Pf))^2
d_decibels = 10log10.(d)

contour(Pf, Pd, d_decibels, labels = true)
```
)

== Processing Gain

== Detection Threshold

== Signal Excess

== Transition Detection Probability

== Figure of Merit
