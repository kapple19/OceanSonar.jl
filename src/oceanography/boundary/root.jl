export Boundary

abstract type Boundary <: Univariate end

include("altimetry.jl")
include("bathymetry.jl")