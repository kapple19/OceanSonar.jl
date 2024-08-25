export Propagation
export PropagationConfig
export default_ranges
export default_depths
export propagationplot!
export propagationplot

"""
TODO.
"""
abstract type PropagationConfig <: Config end

@parse_models_w_args_kwargs PropagationConfig

"""
TODO.
"""
abstract type Propagation <: Result end

@parse_models_w_args_kwargs Propagation

const DEFAULT_NUM_RANGES = 251
const DEFAULT_NUM_DEPTHS = 201

default_ranges(scen, N = DEFAULT_NUM_RANGES) = range(0, scen.x, N)
default_depths(scen, N = DEFAULT_NUM_DEPTHS) = range(depth_extrema(scen)..., N)

include("trace/root.jl")
include("parabolic/root.jl")

PropagationConfig(::Val{:trace}; kwargs...) = TraceConfig(; kwargs...)
PropagationConfig(::Val{:parabolic}; kwargs...) = ParabolicConfig(; kwargs...)

Propagation(::Val{:trace}, args...; kwargs...) = Trace(args...; kwargs...)
Propagation(::Val{:parabolic}, args...; kwargs...) = Parabolic(args...; kwargs...)

function propagationplot! end
function propagationplot end