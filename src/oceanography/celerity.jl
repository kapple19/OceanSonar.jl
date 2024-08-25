export Celerity

@kwdef mutable struct Celerity <: OcnSon
	fun::Function = () -> nothing
end

function (cel::Celerity)(x::Real, z::Real)
	cel.fun(x, z)
end