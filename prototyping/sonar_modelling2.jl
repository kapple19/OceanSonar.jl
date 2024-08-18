## Modelling Abstractions
abstract type OceanSonarModel <: Function end

## Computations
struct BeamConfig <: Configuration

end

struct Beam
    path
    pressure

    Beam(::Model{:Ray})
    Beam(::Model{:Hat})
    Beam(::Model{:Gaussian})
end

struct Trace <: AbstractArray{<:Beam, 2}
    beams::AbstractArray{<:Beam, 2}

    Trace(model::Model{M}) where M = new() # inherits models from `Beam`
end

struct Propagation
    r
    z
    θ
    p

    Propagation(::Model{:Trace}) = new()
    Propagation(::Model{:Trace}) = new()
end

@kwdef struct PerformanceConfiguration <: Configuration end

struct Performance
    model::Model{M} where {M}
    configuration::PerformanceConfiguration

    r::Vector{Float64}
    z::Vector{Float64}
    θ::Vector{Float64}

    SL
    PL
    TS
    NL
    AG
    RL
    SNR
    DT
    SE
    POD

    Performance(::Model{:Multistatic}) = new()
    Performance(::Model{:Bistatic}) = new()
    Performance(::Model{:Monostatic}) = new()
end

Configuration(::Type{<:Performance}; opt...) = PerformanceConfiguration(; opt...)

## 
