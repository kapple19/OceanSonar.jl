export atmosphere_density_profile
export AtmosphereDensityProfile

@implement_environment_function_and_functor Density Atmosphere

## Models
atmosphere_density_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 1.225)::Real = ρ
