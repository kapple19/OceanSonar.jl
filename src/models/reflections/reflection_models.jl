include("Reflections.jl")

"""
List of acoustic media interface reflection models.
"""
reflections = list_models(Reflections)

"""
```
function reflection_coefficient(model, args..., kwargs...)
```
"""
function reflection_coefficient(model, args...; kwargs...)
    !(model in reflections) && error("unrecognised reflection model.")

    fcn = getproperty(Reflections, Symbol(model))

    fcn(args...; kwargs...)
end