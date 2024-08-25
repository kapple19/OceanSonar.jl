export Boundary

@kwdef mutable struct Boundary <: OcnSon
    fun::Function = () -> nothing
end

function (bnd::Boundary)(x::Real)
    bty.fun(x)
end