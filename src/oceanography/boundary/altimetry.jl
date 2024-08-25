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
altimetry(:sine, 1e3)
altimetry(:sine, 1e2)
```
"""
function altimetry end

altimetry(::Val{:flat}, x::Real) = 0.0

sine_default = (
    a = 500.0,
    f = 1e-4,
    s = 0.0
)

ocnson_sin(x::Real) = NaNMath.sin(x)
ocnson_sin(x::Interval) = sin(x)

function altimetry(::Val{:sine},
    x::Real;
    a::Real = sine_default.a,
    f::Real = -sine_default.f,
    s::Real = sine_default.s
)
    a * ocnson_sin(2π * f*(x - s))
end

# function altimetry(::Val{:sine},
#     x::Interval;
#     a::Real = sine_default.a,
#     f::Real = sine_default.f,
#     s::Real = sine_default.s
# )
#     a * sin(2π * f*(x - s))
# end

@parse_models_w_args_kwargs altimetry

"""
TODO.
"""
struct Altimetry <: Boundary
    model::Val
end

(ati::Altimetry)(x::Real; kwargs...) = altimetry(ati.model, x; kwargs...)

@parse_models Altimetry

Altimetry() = Altimetry(:flat)

list_model_symbols(::Type{Altimetry}) = list_model_symbols(altimetry)