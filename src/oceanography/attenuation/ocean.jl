export ocean_attenuation
export OceanAttenuation

"""
TODO.
"""
function ocean_attenuation end

"""
dB/m

Equation 1.47 of Jensen, et al (2011).
"""
function ocean_attenuation(::Val{:jensen}, x::Real, z::Real, f::Real)
    f² = f^2
    3.3 + 110f² / (1 + f²) + 44000f² / (4100 + f²) + 0.3f²
end

@parse_models_w_args ocean_attenuation

"""
TODO.
"""
struct OceanAttenuation <: Attenuation
    model::Val
end

function (atn::OceanAttenuation)(x::Real, z::Real, f::Real)
    ocean_attenuation(atn.model, x, z, f)
end

@parse_models OceanAttenuation

OceanAttenuation() = OceanAttenuation(:jensen)

list_model_symbols(::Type{OceanAttenuation}) = list_model_symbols(ocean_attenuation)