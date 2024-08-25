module OceanSonarMakieExt

using OceanSonar
using Makie

import OceanSonar:
    colour,
    visual!, visual
import Makie: convert_arguments

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
            # @info "Including: $subpath"
            subpath
        else
            error("What is ", subpath, "?")
        end |> include
    end
end

include_subroots(@__FILE__)

end