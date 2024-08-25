export ocean_celerity
export OceanCelerity

@doc """
```
c::Float64 = ocean_celerity(model, x::Real, z::Real; kwargs...)
```

Calculation of sound speed in the ocean.

* `model` name of celerity model
* `x` horizontal range (m)
* `z` depth (m), positive downwards
* `c` celerity (m/s) of sound in the ocean for the specified `model`
* `kwargs...` keyword arguments, see specific `model` documentations.

Example:

```
c = ocean_celerity(:munk, 1e3, 1e2; ϵ = 1e-3)
```
"""
function ocean_celerity end

"""
```
c::Float64 = ocean_celerity(::Val{:homogeneous}, x::Real, z::Real)
```

Returns a constant sound speed value `c == 1500.0` for all ranges and depths.
"""
ocean_celerity(::Val{:homogeneous}, x::Real, z::Real) = 1500.0

"""
```
c::Float64 = ocean_celerity(:munk, x::Real, z::Real; ϵ = 7.37e-3)
```

Calculation of ocean sound speed by Equation 5.83 of Jensen, et al (2011).
This model is range independent and depth dependent.

* `ϵ` A factor (unitless) for variation with depth,
e.g. `ϵ = 0` gives a homogenous sound speed of 1500 m/s.
"""
function ocean_celerity(::Val{:munk}, x::Real, z::Real; ϵ = 7.37e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

"""
```
c::Float64 = ocean_celerity(:index_squared, x::Real, z::Real; c₀ = 1550.0)
```

Calculation of ocean sound speed by Equation 3.77 of Jensen, et al (2011).
This model is range independent and depth dependent.

* `c₀` Sound speed at `z = 0`.
"""
function ocean_celerity(::Val{:index_squared}, x::Real, z::Real; c₀ = 1550.0)
    c₀ / NaNMath.sqrt(1 + 2.4z / c₀)
end

@parse_models_w_args_kwargs ocean_celerity

"""
```
OceanCelerity(model::Val)
```

Construction of a data container for storing the desired `model`.

Built-in models are: TODO
"""
struct OceanCelerity <: Celerity
    model::Val
end

function (cel::OceanCelerity)(x::Real, z::Real; kwargs...)
    ocean_celerity(cel.model, x, z; kwargs...)
end

@parse_models OceanCelerity

OceanCelerity() = OceanCelerity(Symbol())

list_model_symbols(::Type{OceanCelerity}) = list_model_symbols(ocean_celerity)