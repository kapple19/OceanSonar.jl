export atmosphere_attenuation
export AtmosphereAttenuation

"""
TODO.
"""
function atmosphere_attenuation end

atmosphere_attenuation(::Val{:standard}, x::Real, z::Real, f::Real) = 0.0

@parse_models_w_args atmosphere_attenuation

"""
TODO.
"""
struct AtmosphereAttenuation <: Attenuation
    model::Val
end

function (atn::AtmosphereAttenuation)(x::Real, z::Real, f::Real)
    atmosphere_attenuation(atn.model, x, z, f)
end

@parse_models AtmosphereAttenuation

AtmosphereAttenuation() = AtmosphereAttenuation(:standard)

list_model_symbols(::Type{AtmosphereAttenuation}) = list_model_symbols(atmosphere_attenuation)