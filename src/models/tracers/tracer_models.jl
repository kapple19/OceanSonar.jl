include("Tracers.jl")

"""
`tracers::Vector{String}`

List of tracer models.
"""
tracers = list_models(Tracers)

function Structures.Tracer(model::String)
    !(model in tracers) && error("Unrecognised tracer model.")
    getproperty(Tracers, Symbol(model))
end

include("TraceMethod.jl")