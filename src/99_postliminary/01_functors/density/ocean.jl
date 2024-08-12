export ocean_density_profile
export OceanDensityProfile

@implement_spatially_modelled_function_and_functor OceanDensityProfile 3

ocean_density_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 1029.0)::Real = ρ
