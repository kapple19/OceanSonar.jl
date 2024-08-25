export atmosphere_density
export AtmosphereDensity

@implement_3D_modelling atmosphere_density

atmosphere_density(::Val{:standard}, x::Real, y::Real, z::Real) = 1.225
