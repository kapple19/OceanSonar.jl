export bathymetry
export Bathymetry

bathymetry(::Val{:canonical_deep}, ::Real) = 5000.0
bathymetry(::Val{:canonical_shallow}, ::Real) = 100.0
bathymetry(::Val{:canonical_average}, ::Real) = 3682.0
bathymetry(::Val{:mesopelagic}, ::Real) = 1000.0

function bathymetry(::Val{:parabolic}, x::Real)
    b = 250e3
    c = 250.0
    z = 2e-3b * √(1 + x/c)
end

@add_model_conversion_methods bathymetry

Bathymetry() = Boundary{:bathymetry}()
Bathymetry(model) = Boundary{:bathymetry}(model)

function (bnd::Boundary{:bathymetry})(args...; kwargs...)
    bathymetry(bnd.model, args...; kwargs...)
end