# OceanSonar

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kapple19.github.io/OceanSonar.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kapple19.github.io/OceanSonar.jl/dev/)
[![Build Status](https://github.com/kapple19/OceanSonar.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/kapple19/OceanSonar.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## Citing

See [`citation.bib`](CITATION.bib) for the relevant reference(s).

## Roadmap

Usage Features:

* Ocean sonar related environmental metrics (ocean sound speed, life noise, metric conversions, etc).
* Acoustic propagation models with modular components (beam types, coherence, etc).
* The sonar equation and calculation of its many terms.
* Detection performance metrics applied to the signal-to-noise ratio.
* Acausal modelling of the sonar equation and detection algorithms.
* Easy and interactive visualisations of all of the above.
* Graphical user interface/dashboards for streamlining usage and accessibility.

Implementation Features:

* Model name-based dispatch and handling avoids boilerplate and enables user extensibility.
* Modularisation of model components enables easy comparisons and the design of an algorithm for default best choices based on inputs ala `solve` from `DifferentialEquations.jl`.
* Interpolation methods built into the implementations to further enable user extensibility.
* Functor type system keeps external functions safe from this package's implementation design (e.g. `listmodels` will only work on `OceanSonar.AbstractModellingType` types and objects).
* Acausal modelling enabling the single implementation to flexibly apply for declaring different components of the sonar equation as the unknown to compute for.

## References

TODO.
