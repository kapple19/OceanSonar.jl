# OceanSonar

[![Build Status](https://gitlab.com/aaronjkaw/OceanSonar.jl/badges/main/pipeline.svg)](https://gitlab.com/aaronjkaw/OceanSonar.jl/pipelines)
[![Coverage](https://gitlab.com/aaronjkaw/OceanSonar.jl/badges/main/coverage.svg)](https://gitlab.com/aaronjkaw/OceanSonar.jl/commits/main)

## Purpose

Prolific implementations of acoustic propagation models already exist. Why another one?

* The [two-language problem](https://scientificcoder.com/how-to-solve-the-two-language-problem). Albeit [with a 1.5 language problem now](https://www.youtube.com/watch?v=RUJFd-rEa0k), which is still less than two.
* Computation, visualisation, and documentation is all handled by one language.
* I can implement extremely flexible modularity of models.
* Favourable testing framework design.
* Sufficiently feature-rich and amazingly performant package ecosystem.
* CAS. TODO: motivate.
* Automatic differentiation facilities.

## Citing

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).

## Tasks

* [ ] Add `IntervalArithmetic.jl` for boundary extrema calculations.
* [ ] Move auxiliary and model functions to appropriate locations.
