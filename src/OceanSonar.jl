module OceanSonar

import Base: show, length, iterate, get
using NaNMath
using IntervalArithmetic: Interval, interval
using LinearAlgebra: dot
using Interpolations: linear_interpolation, Flat
using Statistics: mean, std
using ForwardDiff: derivative
using OrdinaryDiffEq:
    ODEProblem,
    solve,
    CallbackSet,
    ContinuousCallback,
    Tsit5,
    terminate!
using PrecompileTools: @setup_workload, @compile_workload

include("preliminary/root.jl")
include("oceanography/root.jl")
include("acoustics/root.jl")
include("processing/root.jl")
include("postliminary/root.jl")

end