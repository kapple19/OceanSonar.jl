export ocean_density
export OceanDensity

@implement_modelling ocean_density 3

ocean_density(::Val{:homogeneous}, x::Real, y::Real, z::Real) = 1027.0
