module RayTrace
using ..OACBase
using Statistics: mean
using ForwardDiff: derivative
using OrdinaryDiffEq: ODEProblem, solve, Tsit5, ContinuousCallback, CallbackSet, terminate!
using RecipesBase: RecipesBase #= check =#, @userplot, @recipe, @series
using DocStringExtensions: TYPEDFIELDS, TYPEDEF, TYPEDSIGNATURES

include("raytrace/auxiliaries.jl")
include("raytrace/defaults.jl")
include("raytrace/field.jl")
include("raytrace/recipes.jl")
include("raytrace/exports.jl")

end # module RayTrace

using .RayTrace
export RayTrace

include("raytrace/exports.jl")