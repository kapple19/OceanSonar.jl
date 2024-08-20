public MetricFunction
public metric_functions

"""
`ModelFunction`

Abstract supertype of all `OceanSonar`'s `Model`-dispatching functions.
"""
abstract type ModelFunction <: Function end

"""
```
OceanSonar.MetricFunction <: Function
```

Called instances dispatch its first argument as `Symbol` or `AbstractString`
to [`Model`](@ref).

E.g.

```julia
using OceanSonar
sound_speed isa OceanSonar.MetricFunction
import OceanSonar: sound_speed
sound_speed(::Model{:MyModel}, z::Real) = 1500.0 + exp(-z^2)
sound_speed(Model(:MyModel), 1e3)
sound_speed(:MyModel, 1e3)
sound_speed("My Model", 1e3)
```

See also: [`Model`](@ref).
"""
abstract type MetricFunction <: ModelFunction end

function (fcn::ModelFunction)(model::Union{Symbol, <:AbstractString}, args...; kws...)
    fcn(Model(model), args...; kws...)
end

function getdoc(MetricFunctionSubtype::Type{<:MetricFunction})
    """
    ```
    $(string(MetricFunctionSubtype))
    ```

    Subtype of `MetricFunction`.
    """
end

"""
```
OceanSonar.metric_functions :: Vector{<:OceanSonar.MetricFunction}
```

`Vector` of `MetricFunction`s defined in `OceanSonar`.
"""
metric_functions = MetricFunction[]
