# OceanSonar.jl Usage

TODO: Link OceanSonar.jl definition names to their documentation.

## Installation

As OceanSonar.jl is a Julia package, it requires the Julia programming language.

1. Install Julia using the instructions [here](https://julialang.org/downloads/).
2. Open a Julia REPL (terminal).
3. Activate the `Pkg` mode by pressing `]` (at the beginning of the line).
4. Enter `add https://github.com/kapple19/OceanSonar.jl` which installs the `OceanSonar.jl` package.
5. Return to the `Julian` mode by backspacing (at the beginning of the line).
6. Enter `using OceanSonar` to load the package.

Registered packages require only `add OceanSonar`,
which is not yet the case for this package under development.

## Functions

The functions defined by OceanSonar.jl are:

* `atmosphere_celerity`
* `ocean_celerity`
* `seabed_celerity`
* `shear_seabed_celerity`
* TODO: programmatically produce this list.

View their respective documentation for more details.

## Containers

Data containers available for storing information are:

* `Medium`
* `Slice`
* TODO: programmatically produce this list.

## Functors

Functors are data containers that can be run like functions.
The functor types defined by OceanSonar.jl available for instantiation are:

* `AtmosphereCelerity`
* `OceanCelerity`
* `SeabedCelerity`
* `ShearSeabedCelerity`
* TODO: programmatically produce this list.

Their usage, for example:

```julia
using OceanSonar

models = list_models(OceanCelerity)
cel = OceanCelerity(models[1])

cel(0, 1e3)
```

## Built-In Models

For any of the functions, containers, and functor types listed above,
run `list_models` on them to list the available models for usage.

```@docs
list_models
```

## Custom User Models

Models are implemented in Julia as methods signed with a [`Val{Symbol}`](https://docs.julialang.org/en/v1/base/base/#Base.Val) as the first input.
The `Symbol` instance must be snake-case.
For example, to add custom models for ocean sound speed:

```julia
using OceanSonar
import OceanSonar: ocean_celerity

function ocean_celerity(::Val{:sinusoidal}, x, z)
    1500 + sin(x) - cos(z)
end

ocean_celerity(::Val{:depth_decreasing}, x, z) = 1500.0 + 20exp(-z)
```

which becomes available as

```julia
ocean_celerity("Sinusoidal", 1e2, 1e3)
```

and

```julia
ocean_celerity("Depth Decreasing", 0, 100)
```

Some models are interpolations of data points.

```@docs
Univariate
Bivariate
Trivariate
```

For example,

```julia
using OceanSonar
using CairoMakie

ranges = 1e3 * [0, 5, 6, 7, 10]
depths = 1e3 * [5, 5, 2, 5, 5]

itp = Univariate(ranges, depths)
bathymetry(::Val{:triangular_seamount}, x) = itp(x)

bty = Bathymetry("Triangular Seamount")
visual(bty)
```

Note that the pascal-case `Bathymetry <: Univariate`,
but the `Univariate` instance is used to define the snake-case `bathymetry` method.

## Visualisation

OceanSonar.jl comes with [package extensions](https://docs.julialang.org/en/v1/manual/code-loading/#man-extensions)
for backends [Plots.jl](https://docs.juliaplots.org/stable/)
and [Makie.jl](https://docs.makie.org/stable/).
The extensions define recipes for:

* `OceanCelerity`
* TODO: Programmatically produce this list.

So you can use either plotting backend's plotting functions on instances of the above-listed types.

OceanSonar.jl also provides `visual` which acts as a convenience function for plotting multiple features with one function call.
Its mutating version `visual!` is also provided.

```@docs
visual!
visual
```

## Other Auxiliaries

Formatting a string of the model's name has been wrapped into the following functions:

```@docs
modelsnake
modeltitle
modelsymbol
```
