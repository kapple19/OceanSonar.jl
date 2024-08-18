export altimetry_profile

@implement_model_function altimetry_profile

altimetry_profile(::Model{:Homogeneous}, x::Real, y::Real; z::Real) = z

altimetry_profile(::Model{:Flat}, x::Real, y::Real) = altimetry_profile(:Homogeneous, x, y; z = 0.0)
