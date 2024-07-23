module OceanSonar

import Base: extrema, Pairs, show, String, Symbol

using IntervalArithmetic: Interval, interval
using NaNMath:
    cos as nan_cos,
    hypot as nan_hypot,
    sin as nan_sin,
    sincos as nan_sincos,
    sqrt as nan_sqrt
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

end
