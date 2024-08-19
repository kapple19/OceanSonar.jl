struct Propagation <: ModelComputation
    r::Vector{Float64}
    z::Vector{Float64}
    θ::Vector{Float64}

    p::Array{Complex{Float64}, 3}
    PL::Array{Float64, 3}

    Propagation(
        r::AbstractVector{<:Real},
        z::AbstractVector{<:Real},
        θ::AbstractVector{<:Real},
        p::AbstractArray{<:Complex{<:Real}, 3},
        PL::AbstractArray{<:Real, 3},
    ) = new(r, z, θ, p, PL)
end
