export shear_seabed_attenuation
export ShearSeabedAttenuation

"""
TODO.
"""
function shear_seabed_attenuation end

shear_seabed_attenuation(::Val{:jensen_clay}, x::Real, z::Real, f::Real) = 1.0
shear_seabed_attenuation(::Val{:jensen_silt}, x::Real, z::Real, f::Real) = 1.5
shear_seabed_attenuation(::Val{:jensen_sand}, x::Real, z::Real, f::Real) = 2.5
shear_seabed_attenuation(::Val{:jensen_gravel}, x::Real, z::Real, f::Real) = 1.5
shear_seabed_attenuation(::Val{:jensen_moraine}, x::Real, z::Real, f::Real) = 1.0
shear_seabed_attenuation(::Val{:jensen_chalk}, x::Real, z::Real, f::Real) = 0.5
shear_seabed_attenuation(::Val{:jensen_limestone}, x::Real, z::Real, f::Real) = 0.2
shear_seabed_attenuation(::Val{:jensen_basalt}, x::Real, z::Real, f::Real) = 0.2

@parse_models_w_args shear_seabed_attenuation

"""
TODO.
"""
struct ShearSeabedAttenuation <: Trivariate
    model::Val
end

function (shear_atn::ShearSeabedAttenuation)(x::Real, z::Real, f::Real)
    shear_seabed_attenuation(shear_atn.model, x, z, f)
end

@parse_models ShearSeabedAttenuation

ShearSeabedAttenuation() = ShearSeabedAttenuation(Symbol())

list_model_symbols(::Type{ShearSeabedAttenuation}) = list_model_symbols(shear_seabed_attenuation)