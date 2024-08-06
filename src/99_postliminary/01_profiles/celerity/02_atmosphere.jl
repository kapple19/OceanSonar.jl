export atmosphere_celerity_profile

## Instantiation
const atmosphere_celerity_profile = CelerityProfileFunctionType{Atmosphere}()

## Models
atmosphere_celerity_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 343.0)::Real = c
