#set heading(numbering: none)

#align(center, text(17pt)[*Ocean Sonar*])

= Preface

#outline(depth: 1, indent: auto)

#set heading(numbering: "1.")

= Software Background: The Julia Programming Language

== `OceanSonar.jl`
== `Unitful.jl`
== `Makie.jl`
== Automatic Differentiation Packages
== `DifferentialEquations.jl`
== Scientific Machine Learning (SciML)

= Mathematical Background

== Physical Quantities

=== Logarithmic Scales

== Special Functions

=== Standard Normal Cumulative Distribution Function
=== Error Function
=== Complementary Error Function
=== Green's Function

== Discrete Statistical Distributions

== Continuous Statistical Distributions

=== Uniform
=== Dirac
=== Rectangular
=== Gaussian

== Window Functions

The continuous-domain window function definitions are provided in the following sections.
The respective discrete-domain window is related to its continuous-domain window function as TODO.

=== Rectangular
=== Hann
=== Hamming
=== Kaiser

== Sampling

=== Efficient Curve Sampling for Minimum Linear Error
=== Equidistributed Spherical Points

#align(center, text(14pt)[*Sonic Oceanography*])

= The Ocean Volume

== Range
== Depth
== Density
== Pressure
== Temperature
== Salinity
== Sound Speed
== Attenuation

= The Atmosphere and Ocean Surface

== Altimetry
== Roughness
== Ambience

= The Seabed and Ocean Bottom

== Bathymetry
== Layers
== Roughness
== Density
== Sound Speed
== Attenuation

= The Ocean Life

== Whales
== Fish
== Shrimp

#align(center, text(14pt)[*Ocean Acoustics*])

= Acoustic Dynamics

== Acoustic Medium Propagation

=== Spreading Loss

==== Spherical
==== Cylindrical
==== Transition
==== Multipath

=== Absorption Loss

== Acoustic Interface Reflection

=== Ocean Surface Reflection
=== Ocean Surface

== Acoustical Scattering and Reverberation

= Green's Function
= Normal Modes
= Beam Tracing

== Ray Tracing
== Beam Models

=== Hat Beams
=== Gaussian Beams

== 2D Beam Tracing
== 2.5D Beam Tracing
== 3D Beam Tracing

= Parabolic Equation
= Finite Difference
= Finite Element
= Finite Volume

#align(center, text(14pt)[*Signal Processing*])

= Hydroacoustic Transducers
= Signal and Noise Models
= Ocean Sonar Arrays

== Beampatterns
== Beamforming
== Array Gain
== Directivity Index

= Ocean Vessels

== Target Strength

= Ocean Sonar Processing

== Passive Sonar Processing

=== Exposure

==== Narrowband Processing
==== Broadband Processing

=== Intercept

==== Continuous Wave Signals
==== Frequency Modulated Signals

== Active Sonar

=== Active Sonar Geometries

==== Monostatic
==== Bistatic
==== Multistatic

=== Active Sonar Processing

==== Continuous Wave Signals
==== Frequency Modulated Signals

#align(center, text(14pt)[*Statistical Detection*])

= Sonar Detectors

== Hypothesis Testing and Probability Metrics
== Detection Index
== Detection Threshold
== Signal Excess
== Transition Probability of Detection

= Sonar Performance
