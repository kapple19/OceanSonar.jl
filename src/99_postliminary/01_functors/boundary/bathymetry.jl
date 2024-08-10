export bottom_boundary_profile
export BathymetryProfile

@implement_environment_function_and_functor Boundary Bottom
const bathymetry_profile = bottom_boundary_profile
BathymetryProfile = BottomBoundaryProfile

bottom_boundary_profile(::ModelName{:Flat}, x::Real, y::Real; z::Real) = z

bottom_boundary_profile(::ModelName{:Epipelagic}, x::Real, y::Real) = 100.0
bottom_boundary_profile(::ModelName{:Mesopelagic}, x::Real, y::Real) = 1e3
bottom_boundary_profile(::ModelName{:Bathypelagic}, x::Real, y::Real) = 4e3
bottom_boundary_profile(::ModelName{:Abyssopelagic}, x::Real, y::Real) = 6e3

bottom_boundary_profile(::ModelName{:Bottomless}, x::Real, y::Real) = Inf

function bottom_boundary_profile(::ModelName{:Parabolic}, x::Real, y::Real;
    b = 250e3, c = 250.0
)
    r = hypot(x, y)
    2e-3b * sqrt(1 + r/c)
end
