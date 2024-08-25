export seabed_attenuation
export SeabedAttenuation

"""
TODO.
"""
function seabed_attenuation end

seabed_attenuation(::Val{:jensen_clay}, x::Real, z::Real, f::Real) = 0.2
seabed_attenuation(::Val{:jensen_silt}, x::Real, z::Real, f::Real) = 1.0
seabed_attenuation(::Val{:jensen_sand}, x::Real, z::Real, f::Real) = 0.8
seabed_attenuation(::Val{:jensen_gravel}, x::Real, z::Real, f::Real) = 0.6
seabed_attenuation(::Val{:jensen_moraine}, x::Real, z::Real, f::Real) = 0.4
seabed_attenuation(::Val{:jensen_chalk}, x::Real, z::Real, f::Real) = 0.2
seabed_attenuation(::Val{:jensen_limestone}, x::Real, z::Real, f::Real) = 0.1
seabed_attenuation(::Val{:jensen_basalt}, x::Real, z::Real, f::Real) = 0.1

@parse_models_w_args seabed_attenuation

"""
TODO.
"""
struct SeabedAttenuation <: Attenuation
    model::Val
end

function (den::SeabedAttenuation)(x::Real, z::Real, f::Real)
    seabed_attenuation(den.model, x, z, f)
end

@parse_models SeabedAttenuation

SeabedAttenuation() = SeabedAttenuation(Symbol())

list_model_symbols(::Type{SeabedAttenuation}) = list_model_symbols(seabed_attenuation)