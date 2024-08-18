export seabed_sound_speed_profile

@implement_model_function seabed_sound_speed_profile

seabed_sound_speed_profile(::Model{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 1600.0) = c
