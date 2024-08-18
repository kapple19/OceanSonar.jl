export Atmosphere

@implement_model_function Atmosphere

Atmosphere(::Model{:Homogeneous}) = Medium(
    c = (x::Real, y::Real, z::Real) -> atmosphere_sound_speed_profile(:Homogeneous, x, y, z)
)
