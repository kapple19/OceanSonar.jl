module OceanSonarMakieExt

## Imports
import Makie:
    convert_arguments,
    plot!

using Makie:
    AbstractAxis,
    Axis,
    current_axis,
    Figure,
    FigureAxisPlot,
    lines!,
    Theme,
    @recipe

import OceanSonar:
    OceanAxis2D,
    soundspeedlines2d,
    soundspeedlines2d!,
    visual,
    visual!
    
using OceanSonar:
    Model

## Implementation
"""
```
OceanSonar.include_subroots(path::AbstractString)
```

Trade-off: If adding a file, need to restart REPL session.
"""
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