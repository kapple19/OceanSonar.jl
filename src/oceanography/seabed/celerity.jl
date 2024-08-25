export SeabedCelerity
export seabed_celerity

function SeabedCelerity(model::Val)
    fun(x::Real, z::Real) = seabed_celerity(model, x, z)
    Celerity(fun)
end

"Table 1.3 of Jensen, et al (2011)."
function seabed_celerity(::Val{:clay}, x::Real, z::Real)
    c = 1500.0
end