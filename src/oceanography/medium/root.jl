export Medium

"""
Generic medium container.
"""
abstract type Medium <: Container end

include("atmosphere.jl")
include("ocean.jl")
include("seabed.jl")