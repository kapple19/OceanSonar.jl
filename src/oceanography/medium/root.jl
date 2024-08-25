"""
Generic medium container.
"""
abstract type Medium <: OcnSonContainer end

include("atmosphere.jl")
include("ocean.jl")
include("seabed.jl")