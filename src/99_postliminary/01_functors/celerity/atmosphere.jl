export atmosphere_celerity_profile
export AtmosphereCelerityProfile

## Instantiation
@implement_environment_function_and_functor Atmosphere Celerity

## Models
atmosphere_celerity_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 343.0)::Real = c
