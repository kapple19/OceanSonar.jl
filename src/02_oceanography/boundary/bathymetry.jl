export bathymetry
export Bathymetry

@implement_2D_modelling bathymetry

bathymetry(::Val{:shallow}, x::Real, y::Real) = 1e2
bathymetry(::Val{:half_kilometre}, x::Real, y::Real) = 5e2
bathymetry(::Val{:mesopelagic}, x::Real, y::Real) = 1e3
bathymetry(::Val{:four_kilometers}, x::Real, y::Real) = 4e3
bathymetry(::Val{:deep}, x::Real, y::Real) = 5e3

bathymetry(::Val{:parabolic},
    x::Real, y::Real;
    b = 250e3, c = 250.0
) = 2e-3b * ocnson_sqrt(1 + x/c)
