export Density

abstract type Density <: Bivariate end

include("atmosphere.jl")
include("ocean.jl")
include("seabed.jl")