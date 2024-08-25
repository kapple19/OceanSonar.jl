include("oceanography/boundary.jl")
include("oceanography/bathymetry.jl")
include("oceanography/altimetry.jl")

include("oceanography/celerity.jl")
include("oceanography/ocean/celerity.jl")
include("oceanography/seabed/celerity.jl")
include("oceanography/atmosphere/celerity.jl")

include("oceanography/medium.jl")
include("oceanography/ocean.jl")
include("oceanography/seabed.jl")
include("oceanography/atmosphere.jl")

include("oceanography/environment.jl")

export Scenario

@kwdef mutable struct Scenario <: OcnSon
	env::Environment = Environment()
	x::Float64 = 0.0
	z::Float64 = 0.0
end

function Scenario(model::Val, x::Real, z::Real)
	Scenario(model |> Environment, x, z)
end