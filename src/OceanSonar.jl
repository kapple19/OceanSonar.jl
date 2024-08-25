module OceanSonar

import Base: show, length, iterate
using NaNMath
using IntervalArithmetic: Interval, interval
using LinearAlgebra: dot
using Statistics: mean
using ForwardDiff: derivative
using OrdinaryDiffEq:
    ODEProblem,
    solve,
    CallbackSet,
    ContinuousCallback,
    Tsit5,
    terminate!

include("base/root.jl")
include("auxiliary/root.jl")
include("oceanography/root.jl")
include("acoustics/root.jl")

end