export Trace
export TraceConfig

include("ray.jl")
include("beam.jl")
include("gridder.jl")

"""
TODO.
"""
@kwdef mutable struct TraceConfig <: PropagationConfig
    beam = list_models(Beam)[1]
    gridder = list_models(trace_gridder!)[1]
end

struct Trace <: Propagation
    scen::Scenario
    config::TraceConfig
    beams::Vector{<:Beam}
    x::Vector{<:Float64}
    z::Vector{<:Float64}
    p::Array{<:ComplexF64, 2}
    PL::Array{<:Float64, 2}

    function Trace(
        scen::Scenario,
        beams::Vector{Beam},
        config::TraceConfig = TraceConfig();
        ranges::AbstractVector{<:Real} = default_ranges(scen),
        depths::AbstractVector{<:Real} = default_depths(scen),
    )
        validate(scen)

        p = trace_gridder(config.gridder, beams;
            ranges = ranges,
            depths = depths
        )

        PL = @. -20log10(4π * p |> abs)
        PL = max.(PL, 0.0)
        PL = min.(PL, 100.0)

        new(scen, config, beams, ranges |> collect, depths |> collect, p, PL)
    end
end

function Trace(scen::Scenario, config::TraceConfig = TraceConfig();
    ranges::AbstractVector{<:Real} = default_ranges(scen),
    depths::AbstractVector{<:Real} = default_depths(scen),
    angles::AbstractVector{<:Real} = default_angles(scen)
)
    validate(scen)
    beams = Beams(config.beam, scen; angles = angles)
    Trace(scen, beams, config;
        ranges = ranges,
        depths = depths
    )
end