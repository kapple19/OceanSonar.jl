export shear_seabed_attenuation
export ShearSeabedAttenuation

@implement_modelling shear_seabed_attenuation 3

shear_seabed_attenuation(::Val{:jensen_clay}, x::Real, y::Real, z::Real) = 1.0
shear_seabed_attenuation(::Val{:jensen_silt}, x::Real, y::Real, z::Real) = 1.5
shear_seabed_attenuation(::Val{:jensen_sand}, x::Real, y::Real, z::Real) = 2.5
shear_seabed_attenuation(::Val{:jensen_gravel}, x::Real, y::Real, z::Real) = 1.5
shear_seabed_attenuation(::Val{:jensen_moraine}, x::Real, y::Real, z::Real) = 1.0
shear_seabed_attenuation(::Val{:jensen_chalk}, x::Real, y::Real, z::Real) = 0.5
shear_seabed_attenuation(::Val{:jensen_limestone}, x::Real, y::Real, z::Real) = 0.2
shear_seabed_attenuation(::Val{:jensen_basalt}, x::Real, y::Real, z::Real) = 0.2
