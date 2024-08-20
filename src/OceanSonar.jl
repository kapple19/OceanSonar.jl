"""
`OceanSonar::Module`

Contains a library of ocean sonar numerical modelling implementations.

The main features are:

* In development.

Some auxiliary functionalities are also provided:

* [`textstyle`](@ref) applies a rigorous heuristic for converting between text case styles.

The following extensions have been implemented:

* In development.

See the documentation website (in development) for more information.
"""
module OceanSonar

## Imports
import Base:
    show

using Base:
    kwarg_decl,
    method_argnames

import Base.Docs:
    getdoc

import Core:
    String,
    Symbol

using InteractiveUtils:
    methodswith

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