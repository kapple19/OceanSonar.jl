export atmosphere_density_profile
export AtmosphereDensityProfile

@implement_spatially_modelled_function_and_functor AtmosphereDensityProfile 3

## Models
atmosphere_density_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 1.225)::Real = ρ
