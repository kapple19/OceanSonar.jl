export bathymetry_profile

const bathymetry_profile = BoundaryProfileFunctionType{Bottom}()

bathymetry_profile(::ModelName{:Flat}, x::Real, y::Real; z::Real)::Float64 = z

bathymetry_profile(::ModelName{:Epipelagic}, x::Real, y::Real)::Float64 = 100.0
bathymetry_profile(::ModelName{:Mesopelagic}, x::Real, y::Real)::Float64 = 1e3
bathymetry_profile(::ModelName{:Bathypelagic}, x::Real, y::Real)::Float64 = 4e3
bathymetry_profile(::ModelName{:Abyssopelagic}, x::Real, y::Real)::Float64 = 6e3

bathymetry_profile(::ModelName{:Bottomless}, x::Real, y::Real)::Float64 = Inf

function bathymetry_profile(::ModelName{:Parabolic}, x::Real, y::Real;
    b = 250e3, c = 250.0
)::Float64
    r = hypot(x, y)
    2e-3b * sqrt(1 + r/c)
end
