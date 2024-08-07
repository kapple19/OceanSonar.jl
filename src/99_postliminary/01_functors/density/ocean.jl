export ocean_density_profile
export OceanDensityProfile

@implement_environment_function_and_functor Ocean Density

ocean_density_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 1029.0)::Real = ρ
