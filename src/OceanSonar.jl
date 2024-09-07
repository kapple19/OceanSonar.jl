module OceanSonar

using DataInterpolations:
    AbstractInterpolation,
    CubicSpline,
    LinearInterpolation

using ForwardDiff: ForwardDiff

using IntervalArithmetic: IntervalArithmetic,
    Interval,
    interval

using NaNMath: NaNMath

using Symbolics: Symbolics,
    Num

function include_subroots(current_path::AbstractString)
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
            # @info "Including: $subpath"
            subpath
        else
            error("What is ", subpath, "?")
        end |> include
    end
end

include_subroots(@__FILE__)


end
