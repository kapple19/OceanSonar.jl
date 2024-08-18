export Surface

@implement_model_function Surface

Surface(::Model{:MirroredFlat}) = Interface(
    z = (x::Real, y::Real) -> altimetry_profile(:Flat, x, y),
    R = (x::Real, y::Real) -> reflection_coefficient_profile(:Mirror, x, y)
)

Surface(::Model{:TranslucentFlat}) = Interface(
    z = (x::Real, y::Real) -> altimetry_profile(:Flat, x, y),
    R = (x::Real, y::Real) -> reflection_coefficient_profile(:Translucent, x, y)
)

Surface(::Model{:AbsorbentFlat}) = Interface(
    z = (x::Real, y::Real) -> altimetry_profile(:Flat, x, y),
    R = (x::Real, y::Real) -> reflection_coefficient_profile(:Absorbent, x, y)
)
