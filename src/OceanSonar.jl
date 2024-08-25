module OceanSonar

using NaNMath
using Statistics: mean
using ForwardDiff: derivative
using DifferentialEquations:
    ODEProblem,
    solve,
    CallbackSet,
    ContinuousCallback,
    terminate!,
    Tsit5

include("oceansonarbase.jl")
include("auxiliary.jl")
include("oceanography.jl")
include("acoustics.jl")

end
