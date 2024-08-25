export atmosphere_density
export AtmosphereDensity

"""
TODO.
"""
function atmosphere_density end

atmosphere_density(::Val{:standard}, x::Real, z::Real) = 1.225

@parse_models_w_args atmosphere_density

"""
TODO.
"""
struct AtmosphereDensity <: Density
    model::Val
end

function (den::AtmosphereDensity)(x::Real, z::Real)
    atmosphere_density(den.model, x, z)
end

@parse_models AtmosphereDensity

AtmosphereDensity() = AtmosphereDensity(:standard)

list_model_symbols(::Type{AtmosphereDensity}) = list_model_symbols(atmosphere_density)