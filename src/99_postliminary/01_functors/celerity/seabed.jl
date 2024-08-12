export seabed_celerity_profile
export SeabedCelerityProfile

@implement_spatially_modelled_function_and_functor SeabedCelerityProfile 3

seabed_celerity_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 2000.0)::Real = c
