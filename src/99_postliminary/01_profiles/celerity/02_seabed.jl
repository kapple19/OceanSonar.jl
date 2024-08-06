export seabed_celerity_profile

const seabed_celerity_profile = CelerityProfileFunctionType{Seabed}()

seabed_celerity_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 2000.0)::Real = c
