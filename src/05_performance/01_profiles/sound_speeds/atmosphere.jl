export atmosphere_sound_speed_profile

@implement_model_function atmosphere_sound_speed_profile

atmosphere_sound_speed_profile(::Model{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 343.0) = c
