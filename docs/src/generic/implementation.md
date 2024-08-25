# Ocean Sonar Julia Implementation

The following description of the `OceanSonar.jl` package is intended more as a conceptual guide
rather than a precise description of the implementation.

## Types

The `OceanSonar.jl` package defines four different types of objects,
each serving different purposes.

### Parameter Model Functions

The purpose of model functions is to implement the calculation of a parameter
while providing ease-of-usage for dispatching on different methods to calculate said parameter.

For example, the calculation of sound speed in the ocean has syntax:

```julia
ocean_celerity(model, x, z; kwargs...)
```

Examples of its usage are

```@example
using OceanSonar

ocean_celerity(:munk, 0, 100) # for the Munk profile model
ocean_celerity(:index_squared, 0, 100) # for a sound speed which varies proportional to the squared refractive index
```

The list of models available can be obtained via `list_models` as such:

```@example
using OceanSonar

list_models(ocean_celerity)
```

Other examples of parameter model functions are:

* `atmosphere_celerity` and `seabed_celerity`.
* `atmosphere_density`, `ocean_density`, and `seabed_density` (not yet implemented).
* `altimetry` and `bathymetry`.

### Parameter Model Functors

Parameter model functors store information about one model for one parameter.
As you will see below, this enables collecting multiple functors under conceptual umbrellas.

```@example
using OceanSonar

cel = OceanCelerity(:munk)
cel(1e3, 1e2)
```

Again, to `list_models` for `OceanCelerity` or any functor type,

```@example
using OceanSonar

list_models(OceanCelerity)
```

### Composite Data Containers

The purpose of composite data containers is to store a collection of functors
under a conceptual umbrella. For the example of describing the `Ocean` as an acoustic medium,
(density field not yet implemented):

```julia
using OceanSonar

ocn = Ocean(
    cel = OceanCelerity(:munk),
    den = OceanDensity(:standard)
)
```

where `ocn` stores information as properties of the ocean celerity and the density profiles.
Its usage is then, for example,

```julia
ocn.cel(1e3, 1e2)
```

Models are also implemented for composite data containers,
but for this case they are moreso examples than actual calculation models.
For example,

```@example mutate_composite
using OceanSonar

ocn = Ocean(:munk_profile)
```

and then, if desired, its properties can be mutated:

```@example mutate_composite
ocn.cel = OceanCelerity(:index_squared_profile)
```

And of course, `list_models(Ocean)` provides a list of available `Ocean` models.

Other examples of composite data containers are:

* `Atmosphere` and `Seabed` are analogous medium data containers.
* `Environment`, which stores information about the `Atmosphere`, `Ocean`, and `Seabed`.
* `Scenario` stores an `Environment` instance along with other numerical values.

All of which are compatible with `list_models`.

### Composite Parameter Model Containers

Acting as a combination of the other three types,
composite parameter model containers both compute a model and store multiple information.
A central feature of the `OceanSonar.jl` package is its propagation modelling,
with syntax:

```julia
prop = Propagation(model, scen, ranges, depths)
```

where `model` is one of `list_models(Propagation)`, `scen` is a `Scenario` instance, and `ranges` and `depths` are.

## Visualisation

If you load `Plots.jl` (not implemented yet) or a `Makie.jl` backend,
`OceanSonar.jl` will load plot recipes that enable easy visualisation of instances you've computed.
For example (not yet functional):

```julia
scen = Scenario(:munk_profile)
prop = Propagation(scen)
heatmap(prop) # subject to change
```

The plotting methods provided by your chosen visualisation package
will apply to `OceanSonar.jl` instances as appropriate.

### Ray Trace Plot

TODO.

### Propagation Loss Heatmap

TODO.

### Sonar Performance Visualisation

TODO.

## Expansion

You most certainly have some parameters and models in mind that aren't provided by `OceanSonar.jl`.
The design of this package involves enabling easy expansion of its modelling capabilities.

### Custom Model

Maybe the parameter you wish to calculate is implemented,
but you have a model that isn't implemented.
In this case, adding your model is easy.
Simply `import` the parameter of your choice,
then add a method as in the following example:

```julia
import OceanSonar: ocean_celerity

function ocean_celerity(::Val{:model_name}, x, z)
    return 1500.0 + sin(x) + cos(z)
end
```

and it will be callable as

```julia
ocean_celerity(:model_name, 1e3, 1e2)
```

Note that in the method definition above, the signature involved:

* The model specification as the first argument.
* The model name is implemented as a snake-case `Symbol` parameter to `Val`.

Implementation using `Val` leverages Julia's fast computation via [multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch).

!!! note "Invalid bounds handling"
    Consider using the `NaNMath.jl` package as an alternative to some mathematical functions.
    Normally, Julia's mathematical functions throw an exception when, e.g. out-of-bounds values are hit.
    Some computational methods rely gathering multiple values that may be out of the appropriate domain of the function.
    As such, use e.g. `NaNMath.sqrt` in case its argument is negative,
    or `NaNMath.sin` in case its argument is infinite.

#### Custom Model Interpolation

In some cases, the model you want to implement is not so much a model,
but some data to interpolate.
`OceanSonar.jl` provides methods to both interpolate your data and define your model function.
For example (not yet implemented):

```julia
using OceanSonar
import ocean_celerity

itp = Bivariate()
ocean_celerity(::Val{:model_name}, x, z) = itp(x, z)
```

Usage is highly flexible, and thus its extensive details are explored in [Interpolation](@ref).

### Custom Parameter

Maybe for your intended use case, `OceanSonar.jl` is missing the calculation of a parameter,
e.g. the developer hasn't implemented calculations for ocean salinity yet.

In this case, your definition will be:

```julia
# TODO
```

and then defining models for it as above in [Custom Model](@ref).
