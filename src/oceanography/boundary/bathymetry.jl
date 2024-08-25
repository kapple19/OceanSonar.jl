export bathymetry
export Bathymetry

@doc """
TODO.
"""
function bathymetry end

bathymetry(::Val{:shallow}, x::Real) = 1e2
bathymetry(::Val{:half_kilometre}, x::Real) = 5e2
bathymetry(::Val{:mesopelagic}, x::Real) = 1e3
bathymetry(::Val{:four_kilometers}, x::Real) = 4e3
bathymetry(::Val{:deep}, x::Real) = 5e3

bathymetry(::Val{:parabolic},
    x::Real;
    b = 250e3, c = 250.0
) = 2e-3b * NaNMath.sqrt(1 + x/c)

bathymetry(::Val{:parabolic},
    x::Interval;
    b = 250e3, c = 250.0
) = 2e-3b * sqrt(1 + x/c)

@parse_models_w_args_kwargs bathymetry

"""
TODO.
"""
struct Bathymetry <: Boundary
    model::Val
end

(bty::Bathymetry)(x::Real; kwargs...) = bathymetry(bty.model, x; kwargs...)

@parse_models Bathymetry

Bathymetry() = Bathymetry(Symbol())

list_model_symbols(::Type{Bathymetry}) = list_model_symbols(bathymetry)