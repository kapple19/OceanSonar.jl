# Implementation

## Repository Contents

The filesystem for the package code and documentation texts
are organised in such a way as to be added in
alphanumeric folder-then-contents order.
This way, the complicated contents does not have to be
managed by a plethora of `include` call managements for `src/OceanSonar.jl`,
or the `pages` keyword for `docs/make.jl`.

## `OceanSonar` Modelling Types

The field of ocean sonar consists of many metrics,
each of which have many alternative contexts and methods for calculation.
For simplicity of usage and the avoidance of namespace overpopulation,
`OceanSonar` implements a collection of types
that do much of the heavy lifting in the background.

Firstly:

```@docs
Model
```

The implementation of `Model` is such that a basic user will never need to be aware of it.
It is a specialised version of [`Base.Val`](https://docs.julialang.org/en/v1/base/base/#Base.Val) defined specially for this package.
`Model` cooperates with types defined in `OceanSonar`
so users can call models by their name in a string or a symbol.
For example:

```@repl
using OceanSonar
import OceanSonar: sound_speed_profile
sound_speed_profile(::Model{:MyModel}, z) = 1500 + exp(-z^2)
sound_speed_profile(:MyModel, 1e3)
sound_speed_profile("My Model", 1e3)
```

Thus `Model` behaves as both a dispatching tool and a convenience enabler.
For more advanced users,
it is also accessible for easily extending `MetricFunction` instances.

To [avoid piracy](https://docs.julialang.org/en/v1/manual/style-guide/#Avoid-type-piracy),
this convenience behaviour is only defined for subtypes of `OceanSonar.MetricFunction`:

```@docs; canonical = false
OceanSonar.MetricFunction
```

All metric functions defined by `@implement_metric_function` are listed in `metric_functions`:

```@docs; canonical = false
OceanSonar.metric_functions
```

```@example
using OceanSonar
OceanSonar.metric_functions
```

For each `MetricFunction`, you can view the `Model`s implemented for it
by running `listmodels`:

```@docs
listmodels
```

For each `Model` of a `MetricFunction`, you can view its inputs and parameters
with `listarguments`:

```@docs
listarguments
```

## Visualisation

The `visual` and `visual!` functions have methods described throughout the documentation,
flexibly catering to the variety of types of plots that ocean sonar modelling
benefits from.

Internally `visual` and `visual!` dispatch on the first argument's `Model` specification
to specific `Makie` plotting recipes defined by the extension package `OceanSonarMakieExt`.
Due to the nature of extensions,
such plotting recipe functions are defined with no arguments in `OceanSonar`
then `imported` for overloading in the extension package.

```@docs
visual
visual!
```

```@example
using OceanSonar, CairoMakie
listmodels(visual)
```

Supporting the creation of ocean metric visualisations
is the `OceanAxis2D` function:

```@docs
OceanAxis2D
```
