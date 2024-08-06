struct PropagationConfiguration{Model <: ModelName} <: ConvenienceConfiguration
    coherence::ModelName
    beam::ModelName
end

struct Propagation2D{Model <: ModelName} <: ConvenienceComputation
    config::PropagationConfiguration{Model}

    r::Vector{Float64}
    z::Vector{Float64}
    p::Matrix{ComplexF64}
    PL::Matrix{Float64}
end

struct Propagation3D{Model <: ModelName} <: ConvenienceComputation
    config::PropagationConfiguration{Model}

    # r::Vector{Float64}
    # θ::Vector{Float64}
    x::Vector{Float64}
    y::Vector{Float64}
    z::Vector{Float64}
    p::Array{ComplexF64, 3}
    PL::Array{Float64, 3}
end