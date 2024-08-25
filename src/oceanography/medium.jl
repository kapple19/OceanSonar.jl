export Medium

@kwdef mutable struct Medium <: OcnSon
	cel::Celerity = Celerity()
end