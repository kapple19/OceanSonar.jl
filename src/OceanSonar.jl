module OceanSonar

import Base: extrema, Pairs, show, String, Symbol

using ExprTools: signature
using ForwardDiff: ForwardDiff
using InteractiveUtils: methodswith
using IntervalArithmetic: Interval, interval
using LinearAlgebra: dot, norm
using ModelingToolkit:
    complete,
    Differential,
    ModelingToolkit,
    ODESystem,
    simplify,
    structural_simplify,
    @mtkbuild,
    @parameters,
    @variables
using NaNMath:
    cos as nan_cos,
    hypot as nan_hypot,
    sin as nan_sin,
    sincos as nan_sincos,
    sqrt as nan_sqrt
using OrdinaryDiffEq:
    CallbackSet,
    ContinuousCallback,
    EnsembleProblem,
    EnsembleSolution,
    EnsembleThreads,
    ODEIntegrator,
    ODEProblem,
    ODESolution,
    remake,
    solve,
    Tsit5,
    terminate!
using Symbolics: Num, Symbolics, Term, wrap, @register_symbolic

function include_subroots(current_path)
    current_directory = if isfile(current_path)
        dirname(current_path)
    elseif isdir(current_path)
        current_path
    else
        error("What is ", current_path, "?")
    end

    for subpath in readdir(current_directory, join = true, sort = true)
        if isdir(subpath)
            include_subroots(subpath)
            continue
        elseif isfile(subpath)
            endswith(subpath, "_.jl") && continue
            subpath == current_path && continue
            @debug "Including: $subpath"
            subpath
        else
            error("What is ", subpath, "?")
        end |> include
    end
end

include_subroots(@__FILE__)

trigger_recompilation_by_changing_this_number = 2 # maybe

end
