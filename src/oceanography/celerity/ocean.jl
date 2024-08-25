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

@parse_models_w_args_kwargs ocean_celerity

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

data_linearised_convergence_zones = (
    z = Float64[0, 300, 1200, 2000, 5000],
    c = Float64[1522, 1501, 1514, 1496, 1545]
)

itp_linearised_convergence_zones = Bivariate(
    nothing,
    data_linearised_convergence_zones.z,
    data_linearised_convergence_zones.c
)

"""
```
c::Float64 = ocean_celerity("Linearised Convergence Zones", x::Real, z::Real)
```

Calculation of ocean sound speed by table 1.1 of Jensen, et al (2011).
This model is range (`x` [m]) independent and depth (`z` [m]) dependent.
"""
function ocean_celerity(::Val{:linearised_convergence_zones},
    x::Real, z::Real 
)
    return itp_linearised_convergence_zones(x, z)
end

data_norwegian_sea = (
    z = [0, 145, 250, 500, 750, 1000, 2000, 4000],
    c = [1495, 1500, 1485, 1475, 1477, 1485, 1500, 1525]
)

itp_norwegian_sea = Bivariate(
    nothing,
    data_norwegian_sea.z,
    data_norwegian_sea.c
)

"""
Fig 1.12 of Jensen, et al (2011).
"""
function ocean_celerity(::Val{:norwegian_sea},
    x::Real, z::Real 
)
    return itp_norwegian_sea(x, z)
end

data_north_atlantic = (
    z = Float64[0, 300, 1200, 2e3, 5e3],
    c = Float64[1522.0, 1502, 1514, 1496, 1545]
)

itp_north_atlantic = Bivariate(
    nothing,
    data_north_atlantic.z,
    data_north_atlantic.c
)

"""
TODO of Jensen, et al (2011).
"""
function ocean_celerity(::Val{:north_atlantic},
    x::Real, z::Real 
)
    return itp_north_atlantic(x, z)
end

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