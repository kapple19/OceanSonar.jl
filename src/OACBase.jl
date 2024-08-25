module OACBase
using PlotUtils: cgrad
using RecipesBase: RecipesBase #= check =#, @userplot, @recipe, @series
using IntervalArithmetic: AbstractInterval, Interval, (..)
using Interpolations: linear_interpolation, Line

include("oacbase/types.jl")
include("oacbase/auxiliaries.jl")
include("oacbase/parameters.jl")
include("oacbase/scenarios.jl")
include("oacbase/recipes.jl")
include("oacbase/exports_internal.jl")
include("oacbase/exports_external.jl")

end # module OACBase

using .OACBase

include("oacbase/exports_external.jl")