export seabed_attenuation
export SeabedAttenuation

@implement_3D_modelling seabed_attenuation

seabed_attenuation(::Val{:jensen_clay}, x::Real, y::Real, z::Real) = 0.2
seabed_attenuation(::Val{:jensen_silt}, x::Real, y::Real, z::Real) = 1.0
seabed_attenuation(::Val{:jensen_sand}, x::Real, y::Real, z::Real) = 0.8
seabed_attenuation(::Val{:jensen_gravel}, x::Real, y::Real, z::Real) = 0.6
seabed_attenuation(::Val{:jensen_moraine}, x::Real, y::Real, z::Real) = 0.4
seabed_attenuation(::Val{:jensen_chalk}, x::Real, y::Real, z::Real) = 0.2
seabed_attenuation(::Val{:jensen_limestone}, x::Real, y::Real, z::Real) = 0.1
seabed_attenuation(::Val{:jensen_basalt}, x::Real, y::Real, z::Real) = 0.1
