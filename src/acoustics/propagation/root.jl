export Propagation
export propagationplot!
export propagationplot

"""
```
prop::Propagation = Propagation(model::Val,
    scen::Scenario,
    ranges::AbstractVector{<:AbstractFloat},
    depths::AbstractVector{<:AbstractFloat},
    angles::AbstractVector{<:AbstractFloat}
)
```

* `model` name of `Propagation` model
* `scen` a `Scenario` instance
* `ranges` horizontal range (m) values for 

* `prop` is a `Propagation` instance
whose fields are outlined in individual `model` documentations.
"""
abstract type Propagation <: OcnSonHybrid end

@parse_models_and_arguments Propagation

include("trace/root.jl")

function propagationplot! end
function propagationplot end