struct Propagation <: ModelComputation
    r::Vector{<:Float64}
    θ::Vector{<:Float64}
    z::Vector{<:Float64}

    p::Array{Complex{Float64}, 3}
    PL::Array{Float64, 3}
end