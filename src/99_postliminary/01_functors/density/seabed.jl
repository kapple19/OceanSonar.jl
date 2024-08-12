export seabed_density_profile
export SeabedDensityProfile

@implement_spatially_modelled_function_and_functor SeabedDensityProfile 3

seabed_density_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 3000.0)::Real = ρ
