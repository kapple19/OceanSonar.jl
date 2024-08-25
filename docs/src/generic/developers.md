# Developers

Developers are advised to:

* Follow the [Ocean Sonar Julia Implementation](@ref) conceptual framework.
* Place implementations in their appropriate conceptual hierarchy (TODO: elaborate).
* Implement tests in the `./test` directory, also placed in the appropriate conceptual hierarchy.
* Add docstrings to all names, even unexported names whose documentation is automatedly provided below in [Private API](@ref).
* Follow the [Style Guide](@ref) below.

## Style Guide

TODO: Decide on an external style guide, e.g. Blue or SciML.

The following style guide applies:

* Instances of functors and data containers are abbreviated snake-case forms, e.g. `cel` for `Celerity`, or `ocn_cel` for `OceanCelerity`.
* Parameter model functions are snake-case named, just like `ocean_celerity`. No abbreviation applied.
* Fields of data containers are also abbreviated, which assists in legibility and brevity of nested container calls.
* Abbreviations are 3-4 characters long, but can be joined with underscores, e.g. `ocn_cel` for `OceanCelerity`.
* When the parent context of an instance is obvious, the underscore-joining abbreviation can be shortened, e.g. the field `cel` in an `Ocean` instance.
* Depending on context, variable names resembling mathematical symbols are either scalars, vectors, arrays, or functions, whichever satisfies both sense and brevity, especially for complicated equations.

## Mathematical Implementation Conventions

* `x` is horizontal range.
* `z` is vertical depth, positive downwards.
* `r` is straight-line distance from one point to another.
* `s` is the arc-length of a curve.
* `c` is compressional sound speed, unless stated as shear. Referred to as "celerity" for brevity throughout code and documentation.
* TODO.

## Private API

As assistance in getting started on development,
the following documentation is provided for all unexported names.

```@autodocs; canonical = true
Modules = [OceanSonar]
Public = false
```
