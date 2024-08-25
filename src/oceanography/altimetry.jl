export Altimetry

function Altimetry(model::Val)
    fun(x::Real) = altimetry(model, x)
    Boundary(fun)
end

function altimetry(::Val{:flat}, x::Real)
    z = 0.0
end