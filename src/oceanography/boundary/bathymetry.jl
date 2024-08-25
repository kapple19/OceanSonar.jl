export bathymetry
export Bathymetry

@doc """
TODO.
"""
function bathymetry end

bathymetry(::Val{:deep}, x::Real) = 5e3
bathymetry(::Val{:shallow}, x::Real) = 1e2
bathymetry(::Val{:mesopelagic}, x::Real) = 1e3

bathymetry(::Val{:parabolic},
    x::Real;
    b = 250e3, c = 250.0
) = 2e-3b * NaNMath.sqrt(1 + x/c)

bathymetry(::Val{:parabolic},
    x::Interval;
    b = 250e3, c = 250.0
) = 2e-3b * sqrt(1 + x/c)

@parse_models_and_arguments bathymetry

"""
TODO.
"""
struct Bathymetry <: Boundary
    model::Val
end

Bathymetry() = Bathymetry(Symbol() |> Val)

(bty::Bathymetry)(x::Real; kwargs...) = bathymetry(bty.model, x; kwargs...)

list_models(::Type{Bathymetry}) = list_models(bathymetry)