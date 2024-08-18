export Ocean

@implement_model_function Ocean

Ocean(::Model{:Homogeneous}) = Medium(
    c = (x::Real, y::Real, z::Real) -> ocean_sound_speed_profile(:Homogeneous, x, y, z)
)

Ocean(::Model{:MunkSoundSpeed}) = Medium(
    c = (x::Real, y::Real, z::Real) -> ocean_sound_speed_profile(:Munk, x, y, z)
)

Ocean(::Model{:RefractionSquaredSoundSpeed}) = Medium(
    c = (x::Real, y::Real, z::Real) -> ocean_sound_speed_profile(:RefractionSquared, x, y, z)
)
