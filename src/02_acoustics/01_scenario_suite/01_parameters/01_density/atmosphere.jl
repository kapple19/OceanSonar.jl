export atmosphere_density
export AtmosphereDensity

@implement_modelling atmosphere_density 3

atmosphere_density(::Val{:standard}, x::Real, y::Real, z::Real) = 1.225
