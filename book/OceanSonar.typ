#import "@preview/unify:0.6.0": unit, qty
#import "@preview/jlyfish:0.1.0": *

#set heading(numbering: none)
#set math.equation(numbering: "(1)")
#set cite(form: "prose")

#show heading.where(level: 1): it => {pagebreak(weak: false); it}
#show heading.where(level: 2): it => {pagebreak(weak: false); it}

#read-julia-output(json("OceanSonar-jlyfish.json"))
#jl-pkg(
  "AbstractTrees",
  "CairoMakie",
  "Distributions",
  "InteractiveUtils",
  "Typstry"
)

#align(center, text(17pt)[Ocean Sonar])

== Preface

The field of ocean sonar finds a variety of scenarios which affect the process by which a sonar's performance is calculated.
For each scenario, assumptions can be made to simplify the complicated computations with the obvious trade-off with accuracy,
but even more potentially damaging, a vagueness as to how inaccurate the simplified results are.
While the sonar equation superficially appears very simple,
the calculation of each term and the interplay between the terms vary in complexity as the user desires accuracy.
Even if the modeller desires accuracy,
the variability and uncertainty of reality ensures that,
much like weather forecasting,
there will always be an inaccuracy.
Thus, past a certain point of modelling accuracy,
any further attempts at improvement may not be worth the effort,
or at worst solidify the inaccuracy.

The following anonymous quotation hints at levels of comical relief balanced with frustration at the difficulty of such a field:

#quote(block: true, quotes: true, attribution: [Anonymous])[
  A sonar engineer is a person who poses as an expert on the basis of being able to produce with prolific fortitude an infinite series of incomprehensible formulae calculated with micromatic precision from vague assumptions based on debatable figures taken from inconclusive experiments carried out with instruments of problematic accuracy by a person of dubious reliability and questionable mentality.
]

On a more positive note, the near-infinite complexity of the field of ocean sonar
finds an application of a variety of other fields, including physical oceanography, wave propagation theory, signal processing, and statistical detection theory.
The array of colleagues I've had the pleasure to learn from have been in the field almost all their lives,
and they demonstrate a continual spirit of learning.
An academic enthusiast will find this field a never ending ocean of knowledge for study and exploration,
ranging from theoretical discoveries via literature to practical experiences at sea.

This book serves multiple purposes.
First and foremost, it is an organisation of the author's studies on the field.
Secondly, it is a record of implementations of the field.
Thirdly, it is publicised as a provision of reproducibility for both theoretical derivations, recorded conclusions and uncertainties, and implementations of numerical algorithms.
Lastly, it is a demonstration of the utility of the Julia programming language.

The Julia programming language seeks to fill a role not addressed by other programming languages.
In the words of its creators:

#quote(
  block: true,
  quotes: true,
  attribution: [
    Why We Created Julia | Jeff Bezanson, Stefan Karpinski, Viral B Shah, Alan Edelman
  ]
)[
  We want a language that's open source, with a liberal license. We want the speed of C with the dynamism of Ruby. We want a language that's homoiconic, with true macros like Lisp, but with obvious, familiar mathematical notation like Matlab. We want something as usable for general programming as Python, as easy for statistics as R, as natural for string processing as Perl, as powerful for linear algebra as Matlab, as good at gluing programs together as the shell. Something that is dirt simple to learn, yet keeps the most serious hackers happy. We want it interactive and we want it compiled.

  (Did we mention it should be as fast as C?)

  While we're being demanding, we want something that provides the distributed power of Hadoop — without the kilobytes of boilerplate Java and XML; without being forced to sift through gigabytes of log files on hundreds of machines to find our bugs. We want the power without the layers of impenetrable complexity. We want to write simple scalar loops that compile down to tight machine code using just the registers on a single CPU. We want to write A*B and launch a thousand computations on a thousand machines, calculating a vast matrix product together.
]

The complexity of ocean sonar has been found to be most easily implemented in the Julia programming language's paradigm of multiple dispatch and hierarchical type system,
enabling code that is both performant and accessible.

Lastly, this book was written with as a Typst book, implemented in the Rust programming language
--- a language that fills in the couple of use-case gaps in the Julia programming language, such as difficulties with complicated race conditions and compact distributable binary sizes.

As an introductory text on ocean sonar,
the author hopes that this book's linearly structured flow of knowledge,
explicit explanations of concepts,
and reproducible numerical computations
scratches the same itch as the author's for academic enthusiasts interested in the field of ocean sonar.

#outline(depth: 2, indent: auto)

= Introduction

TODO: Introduce this book's structure.

#set heading(numbering: "1.")
== Pillars of Ocean Sonar

@ainslie aptly defined four academic pillars that uphold the field of ocean sonar. In order of dependency:

+ Sonar Oceanography
+ Ocean Acoustics
+ Sonar Signal Processing
+ Statistical Detection Theory

Sonar oceanography explores the physical and biological properties and phenomena of the ocean, particularly as related to underwater sonar.

Ocean acoustics simulates the behaviour of sound in the ocean.
The parameters explored in sonar oceanography
are applied as the environment for the acoustic propagation.

Sonar signal processing demonstrates a variety of methods
for receiving, producing, and analysing acoustic data in a variety of scenarios in the context of the ocean.
This field is commonly summarised as methods for increasing the signal-to-noise ratio.
The acoustic propagation behaviours modelled in ocean acoustics
are major components to the sonar equation.

Statistical detection theory finds its objective in evaluating decision metrics
for the performance of a modelled sonar.
The sonar equation finds its completion in this field.

Each of these individual fields are complicated in their own rights,
and are dedicated chapters within this book.

== Mathematical Preliminaries

=== Special Functions

==== Error Function and Variations

==== Standard Normal Cumulative Distribution Function

=== Probability and Statistics

== Programming Preliminaries

= Sonar Oceanography

== The Ocean Volume

== The Ocean Surface

== The Ocean Bottom

== The Ocean Life

= Ocean Acoustics

According to ISO 19405:2017 items 3.4.1.3 and 3.4.1.4:

- Propagation loss is the #quote[
  difference between _source level_ (3.3.2.1) in a specified direction, $L_S$,
  and _mean-square sound pressure level_ (3.2.1.1), $L_(p)(bold(x))$, at a specified position $bold(x)$.
] #quote[
  Propagation loss is expressed in decibels (dB).
] #quote[
  The reference value for propagation loss is #qty(1, "m^2").
]

- Transmission loss is the #quote[
  reduction in a specified level between two specified points $bold(x)_1$, $bold(x)_1$ that are within an underwater acoustic field.
] #quote[
  Transmission loss is expressed in decibels (dB).
]

- #quote[The term "transmission loss" is sometimes used as a synonym of propagation loss (3.4.1.4). This use is deprecated.]

== Beam Tracing

== Parabolic Equation

= Sonar Signal Processing

== Signal and Noise Models

== Acoustic Array Design

== Sonar Scenarios

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

A pair of values $(P_f, P_d)$ is referred to as an _operating point_.
The _minimum detectable level_ (MDL) refers to a detection probability of $P_d = 0.5$.

As part of sonar performance evaluation,
it is often more digestible to utilise the probability metrics in percentages.
Respectively:

$
upright("PFA") = 100 P_f \
upright("POD") = 100 P_d
$

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

Xmin = -3
Xmax = 4
NX = 301

mu0 = 0
mu1 = 1
h = mu0 + 3/4 * (mu1 - mu0)

H0 = Normal(mu0, 1)
H1 = Normal(mu1, 1)
X = range(Xmin, Xmax, NX)
p0 = pdf.(H0, X)
p1 = pdf.(H1, X)

fig = Figure()
axis = Axis(fig[1, 1])

lines!(axis, X, p0)
lines!(axis, X, p1)

Xh = range(h, Xmax, NX)

ph0 = pdf.(H0, Xh)
ph1 = pdf.(H1, Xh)

# suspected Makie.jl bug
# band!(axis, Xh, zeros(NX), ph0,
#   color = Makie.LinePattern(
#     direction = Makie.Vec2f0(1),
#     linecolor = fill(Makie.RGB(0, 0, 0), NX)
#   ),
# )
# band!(axis, Xh, zeros(NX), ph1,
#   color = Makie.LinePattern(
#     direction = Makie.Vec2f0(-1),
#     linecolor = fill(Makie.RGB(0, 0, 0), NX)
#   ),
# )

band!(axis, Xh, zeros(NX), ph0, alpha = 0.1)
band!(axis, Xh, zeros(NX), ph1, alpha = 0.1)

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

The _processing gain_ $upright("PG")$ is TODO, expressed as a function of FFT parameters.

The calculation of the processing gain is explored in detail in the following subsections.

=== Broadband

$
upright("PG") = 5log_(10)("BT")
$

where

- $B$: Bandwidth [Hz]
- $T$: Integration Time [sec]

=== Narrowband

$
upright("PG")
$

== Detection Threshold

The _detection threshold_ $upright("DT")$ is the signal-to-noise ratio in decibels required to achieve a specific operating point $(P_f, P_d)$.

The detection threshold can be referred to and defined for different stages of the sonar processing chain, which is elaborated in TODO. As a summary:

- The processing band: $upright("SNR")$ at the hydrophone level after filtering to the frequency band of the signal of interest.
- The beamformer: $upright("SNR")$ after sensor array processing.
- Linear processing: $upright("SNR")$ after the linear portion of detection processing.

The detection threshold after linear processing is defined as

$
upright("DT") = 10log_(10)(d) - upright("PG")
$

where:

- $d$: Detection Index [unitless]
- $upright("PG")$: Processing Gain [dB]

== Signal Excess

The _signal excess_ $upright("SE")$ is computed from the signal-to-noise ratio calculated from the forward problem,
and the detection threshold which is essentially the signal-to-noise ratio calculated from the inverse problem.
The signal excess acts as a convenience metric for a signal-to-noise ratio value of how much a sonar's performance as calculated by the signal-to-noise ratio achieves the required performance specified in the calculation of the detection threshold.

Signal excess is defined as

$
upright("SE") = upright("SNR") - upright("DT")
$

== Transition Detection Probability

While the probability of detection as part of an operating point is used to compute the required signal-to-noise ratio (i.e. detection threshold),
a valuable metric is the devation from the required probability of detection the actual sonar's performance deviates from the required value.
Such a value is termed the _transition detection probability_ to distinguish from the former detection probability.

The transition detection probability $P_d^t$ is defined as

$
P_d^t = upright("Pr"){ T >= h | P_d = 0.5, upright("SNR") = upright("DT") + upright("SE")}
$

which one may note can be obtained by an inversion of the derivations already given throughout this section to obtain $P_d$ as a function of $upright("SE")$.

=== Gaussian Detector Statistic

$
P_d^t = Phi[(10^(upright("SE") / 10) - 1) times Phi^(-1)(1 - P_f)]
$

== Figure of Merit

= Ocean Sonar Performance Modelling

The previous chapters have explored topics of ocean sonar in microscopic detail.
As a conclusion to this book, this chapter amalgamates information from all of the previous chapters,
Modelling is explored here in macroscopic detail,
demonstrating the progressive increase in complexity described in the preface.

#set heading(numbering: none)

#bibliography(
  title: "Academic Bibliography",
  style: "iso-690-author-date",
  "academic_bibliography.yml"
)

= Software Bibliography

Multiple bibliographies are not yet supported.

// #bibliography(
//   title: "Software Bibliography",
//   style: "elsevier-harvard",
//   "software_bibliography.bib"
// )
