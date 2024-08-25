export ocean_density
export OceanDensity

@implement_3D_modelling ocean_density

ocean_density(::Val{:homogeneous}, x::Real, y::Real, z::Real) = 1027.0
