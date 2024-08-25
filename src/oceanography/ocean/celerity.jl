export OceanCelerity
export ocean_celerity

function OceanCelerity(model::Val)
    fun(x::Real, z::Real) = ocean_celerity(model, x, z)
    Celerity(fun)
end

"Equation 5.83 of Jensen, et al (2011)"
function ocean_celerity(::Val{:munk}, x::Real, z::Real)
	ϵ = 7.37e-3
	z̃ = 2(z - 1300.0)/1300.0
	c = 1500.0(1 + ϵ * (z̃ - 1 + exp(-z̃)))
end