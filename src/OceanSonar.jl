module OceanSonar

import Base: Pairs, extrema
import InteractiveUtils: methodswith
import ExprTools: signature
import NaNMath: sqrt as nan_sqrt, cos as nan_cos, sin as nan_sin
import Symbolics: @variables, Num, Term, wrap

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