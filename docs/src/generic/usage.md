# Usage of OceanSonar.jl

For those who already know the field of ocean sonar,
this page is probably all you'll need to know
(on top of knowing how Julia works)
in order to use this package.
The remainder of this documentation
is an introduction to ocean sonar
alongside the syntax of this package's provided tools.

## Installation

Installation in the Julia REPL:

```julia
using Pkg
Pkg.add("OceanSonar")
```

## Loading

Simply:

```julia
using OceanSonar
```

If you wish to add your own model to a parameter, e.g. to `ocean_celerity`:

```julia
import OceanSonar: ocean_celerity
```

See [Expansion](@ref) for more details.

## What does this package provide?

This package provides the means to:

* Calculate parameters
* Define data and store in containers
* Calculate performance metrics
* Visualise containers and metrics
* Add your own calcuation methods

After [Loading](@ref) this package, the names in the following sections are available for use.
As usual, view the help documentation for each
for specific syntax.

Calculate parameters (with model selection):

* `altimetry`
* `bathymetry`
* `atmosphere_celerity`
* `ocean_celerity`
* `seabed_celerity`

Populate data structures (also with model selection):

* `Altimetry`
* `Bathymetry`
* `AtmosphereCelerity`
* `OceanCelerity`
* `SeabedCelerity`
* `Environment`
* `Scenario`

Calculate performance metrics (also with model selection):

* `Propagation`

Visualise data structures and performance metrics - requires either `Plots.jl` or a `Makie.jl` backend.

* `boundaryplot`
* `celerityplot`
* `rayplot`
* `propagationplot`

Add your own model, as per the example below.

### Example: Add Ocean Celerity Model

```julia
import OceanSonar: ocean_celerity
function ocean_celerity(::Val{:my_model}, x::Real, z::Real)
    1500.0 + cos(x)*sin(z)
end
```

which will then be available as

```julia
ocean_celerity(:my_model, 1e3, 1e2)
```

and also available as a model for `OceanCelerity`, i.e.

```julia
using OceanSonar
using CairoMakie
cel = OceanCelerity(:my_model)
celerityplot(cel)
```

### Example: Plot a Ray Trace

```julia
using OceanSonar
using Plots
scen = Scenario(:munk_profile)
prop = Propagation(:trace, scen, angles = :critical)
propagationplot(prop)
```
