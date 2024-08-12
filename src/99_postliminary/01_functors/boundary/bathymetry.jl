export bathymetry_profile
export BathymetryProfile

@implement_spatially_modelled_function_and_functor BathymetryProfile 2

bathymetry_profile(::ModelName{:Flat}, x::Real, y::Real; z::Real) = z

bathymetry_profile(::ModelName{:Epipelagic}, x::Real, y::Real) = 100.0
bathymetry_profile(::ModelName{:Mesopelagic}, x::Real, y::Real) = 1e3
bathymetry_profile(::ModelName{:Bathypelagic}, x::Real, y::Real) = 4e3
bathymetry_profile(::ModelName{:Abyssopelagic}, x::Real, y::Real) = 6e3

bathymetry_profile(::ModelName{:Bottomless}, x::Real, y::Real) = Inf

function bathymetry_profile(::ModelName{:Parabolic}, x::Real, y::Real;
    b = 250e3, c = 250.0
)
    r = hypot(x, y)
    2e-3b * sqrt(1 + r/c)
end
