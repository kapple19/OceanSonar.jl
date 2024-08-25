export altimetry
export Altimetry

@doc """
```
z::Float64 = altimetry(model::Val, x::Real)
```

* `x` (m) horizontal range
* `model` name of model
* `z` (m) ocean surface height

Built-in models are:

$(altimetry |> doc_models)

Examples:

```julia
altimetry(:sine |> Val, 1e3)
altimetry(:sine |> Val, 1e2)
```
"""
function altimetry end

altimetry(::Val{:flat}, x::Real) = 0.0

sine_default = (
    a = 1.0,
    f = 1.0,
    s = 0.0
)

function altimetry(::Val{:sine},
    x::Real;
    a::Real = sine_default.a,
    f::Real = sine_default.f,
    s::Real = sine_default.s
)
    a * NaNMath.sin(2π * f*(x - s))
end

function altimetry(::Val{:sine},
    x::Interval;
    a::Real = sine_default.a,
    f::Real = sine_default.f,
    s::Real = sine_default.s
)
    a * sin(2π * f*(x - s))
end

@parse_models_and_arguments altimetry

"""
TODO.
"""
struct Altimetry <: Boundary
    model::Val

    Altimetry(model::Val = Val(:flat)) = new(model)
end

(ati::Altimetry)(x::Real; kwargs...) = altimetry(ati.model, x; kwargs...)

list_models(::Type{Altimetry}) = list_models(altimetry)