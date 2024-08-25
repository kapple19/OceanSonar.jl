export Bathymetry

function Bathymetry(model::Val)
    fun(x::Real) = bathymetry(model, x)
    Boundary(fun)
end

function bathymetry(::Val{:canonical_deep}, x::Real)
	z = 5e3
end