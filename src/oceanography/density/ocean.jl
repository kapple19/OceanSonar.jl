export ocean_density
export OceanDensity

"""
TODO.
"""
function ocean_density end

"""
```
ρ::Real = ocean_density(:homogeneous, x::Real, z::Real)
```

Section 2.1.1.2 of Ainslie (2010).
"""
ocean_density(::Val{:homogeneous}, x::Real, z::Real) = 1027.0

@parse_models_w_args ocean_density

"""
TODO.
"""
struct OceanDensity <: Density
    model::Val
end

function (den::OceanDensity)(x::Real, z::Real)
    ocean_density(den.model, x, z)
end

@parse_models OceanDensity

OceanDensity() = OceanDensity(:homogeneous)

list_model_symbols(::Type{OceanDensity}) = list_model_symbols(ocean_density)