export Bottom

@implement_model_function Bottom

Bottom(::Model{:ReflectiveDeep}) = Interface(
    z = (x::Real, y::Real) -> bathymetry_profile(:Deep, x, y),
    R = (x::Real, y::Real) -> reflection_coefficient_profile(:Reflective, x, y)
)

Bottom(::Model{:TranslucentDeep}) = Interface(
    z = (x::Real, y::Real) -> bathymetry_profile(:Deep, x, y),
    R = (x::Real, y::Real) -> reflection_coefficient_profile(:Translucent, x, y)
)

Bottom(::Model{:AbsorbentDeep}) = Interface(
    z = (x::Real, y::Real) -> bathymetry_profile(:Deep, x, y),
    R = (x::Real, y::Real) -> reflection_coefficient_profile(:Absorbent, x, y)
)

Bottom(::Model{:ParabolicBathymetry}) = Interface(
    z = (x::Real, y::Real) -> bathymetry_profile(:Parabolic, x, y),
    R = (x::Real, y::Real) -> reflection_coefficient_profile(:Reflective, x, y)
)
