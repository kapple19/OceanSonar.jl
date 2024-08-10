export seabed_celerity_profile
export SeabedCelerityProfile

@implement_environment_function_and_functor Celerity Seabed

seabed_celerity_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 2000.0)::Real = c
