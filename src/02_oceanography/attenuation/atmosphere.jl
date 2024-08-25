export atmosphere_attenuation
export AtmosphereAttenuation

@implement_3D_modelling atmosphere_attenuation

atmosphere_attenuation(::Val{:standard}, x::Real, y::Real, z::Real) = 0.0
