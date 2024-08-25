export atmosphere_attenuation
export AtmosphereAttenuation

@implement_modelling atmosphere_attenuation 3

atmosphere_attenuation(::Val{:standard}, x::Real, y::Real, z::Real) = 0.0
