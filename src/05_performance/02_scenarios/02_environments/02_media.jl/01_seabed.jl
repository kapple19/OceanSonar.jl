export Seabed

@implement_model_function Seabed

Seabed(::Model{:Homogeneous}) = Medium(
    c = (x::Real, y::Real, z::Real) -> seabed_sound_speed_profile(:Homogeneous, x, y, z)
)
