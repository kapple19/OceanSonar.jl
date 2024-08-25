export Celerity

abstract type Celerity <: Bivariate end

include("atmosphere.jl")
include("ocean.jl")
include("seabed/root.jl")

# Discussion point: Should I implement a celerity parser that takes a scenario and returns a function that returns the appropriate medium celerity for the range and depth inputted? I don't know any use cases but it's an interesting idea if it's ever useful. That applies to the other volumetric, multi-media parameters also, like density.