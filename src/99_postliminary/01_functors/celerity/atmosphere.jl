export atmosphere_celerity_profile
export AtmosphereCelerityProfile

## Instantiation
@implement_spatially_modelled_function_and_functor AtmosphereCelerityProfile 3

## Models
atmosphere_celerity_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 343.0)::Real = c
