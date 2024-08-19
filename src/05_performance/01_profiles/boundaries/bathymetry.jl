export bathymetry_profile

@implement_model_function bathymetry_profile

bathymetry_profile(::Model{:Homogeneous}, x::Real, y::Real; z::Real) = z

bathymetry_profile(::Model{:Shallow}, x::Real, y::Real) =
    bathymetry_profile(:Homogeneous, x, y; z = 100.0)

bathymetry_profile(::Model{:Mesopelagic}, x::Real, y::Real) =
    bathymetry_profile(:Homogeneous, x, y; z = 1e3)

bathymetry_profile(::Model{:Deep}, x::Real, y::Real) =
    bathymetry_profile(:Homogeneous, x, y; z = 5e3)

function bathymetry_profile(::Model{:Parabolic}, x::Real, y::Real;
    b = 250e3, c = 250.0
)
    r = hypot(x, y)
    2e-3b * sqrt(1 + r/c)
end
