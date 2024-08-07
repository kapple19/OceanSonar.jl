export seabed_density_profile
export SeabedDensityProfile

@implement_environment_function_and_functor Seabed Density

seabed_density_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 3000.0)::Real = ρ
