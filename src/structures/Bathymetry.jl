"""
```
struct Bathymetry <: OcnSon
```
"""
struct Bathymetry <: OcnSon
    fcn::Function
    x_imp::Vector{<:Float64}

    function Bathymetry(fcn::Function; x_imp::Vector{<:Real} = [-Inf, Inf])
        fcn, x_imp = univariate(fcn, x_imp = x_imp)
        new(fcn, x_imp)
    end
end

(bty::Bathymetry)(args...; kwargs...) = bty.fcn(args...; kwargs...)

function Bathymetry(args...)
    fcn, x_imp = univariate(args...)
    Bathymetry(fcn, x_imp = x_imp)
end