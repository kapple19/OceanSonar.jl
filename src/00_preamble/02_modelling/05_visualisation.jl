export visual
export visual!
export OceanAxis2D

"`InstantiatingVisualFunctionType` is the `typeof(visual)`."
struct InstantiatingVisualFunctionType <: ModelFunction end

"`MutatingVisualFunctionType` is the `typeof(visual!)`."
struct MutatingVisualFunctionType <: ModelFunction end

"""
```
visual(model, args...; kws...)
visual!(model, args...; kws...)
visual!(axis::Axis, model, args...; kws...)
```

Dispatches the `args` and `kws` to the appropriate plotting function,
specified by `model`.

Has no plotting methods until `Makie` is loaded,
which is normally done by loading one of its backends.
`Axis` is from `Makie`.

The `model` can be a `String`, `Symbol`, or [`Model`](@ref) instance.

This wrapper function acts as both a convenience and avoidance
for remembering the many plotting recipes defined in this package.

As per other `OceanSonar` modelling functions,
a list of models is available via `listmodels(visual)` or `listmodels(visual!)`
"""
const visual = InstantiatingVisualFunctionType()

@doc (@doc visual)
const visual! = MutatingVisualFunctionType()

"""
```
OceanAxis2D
```

Behaves as `Makie.Axis` except with the default of `yreversed = true`.

Unusable until `Makie` is loaded.
"""
function OceanAxis2D end
