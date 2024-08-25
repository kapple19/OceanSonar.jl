export Beam

struct Beam
    model::Val

    s_max::Float64
    f::Float64

    r::Function
    z::Function
    ξ::Function
    ζ::Function
    A::Function
    φ::Function
    τ::Function
    p::Function
    q::Function
    c::Function
    θ::Function

    sol::ODESolution

    function Beam(model::Val, sol::ODESolution, sys::ODESystem, f::Real)
        r(s::Real) = sol(s, idxs = sys.r)
        r(s::AbstractVector{<:Real}) = sol(s, idxs = sys.r) |> collect
        z(s::Real) = sol(s, idxs = sys.z)
        z(s::AbstractVector{<:Real}) = sol(s, idxs = sys.z) |> collect
        ξ(s::Real) = sol(s, idxs = sys.ξ)
        ξ(s::AbstractVector{<:Real}) = sol(s, idxs = sys.ξ) |> collect
        ζ(s::Real) = sol(s, idxs = sys.ζ)
        ζ(s::AbstractVector{<:Real}) = sol(s, idxs = sys.ζ) |> collect
        A(s::Real) = sol(s, idxs = sys.A)
        A(s::AbstractVector{<:Real}) = sol(s, idxs = sys.A) |> collect
        φ(s::Real) = sol(s, idxs = sys.φ)
        φ(s::AbstractVector{<:Real}) = sol(s, idxs = sys.φ) |> collect
        τ(s::Real) = sol(s, idxs = sys.τ)
        τ(s::AbstractVector{<:Real}) = sol(s, idxs = sys.τ) |> collect
        c(s::Real) = sol(s, idxs = sys.c)
        c(s::AbstractVector{<:Real}) = sol(s, idxs = sys.c) |> collect
        θ(s::Real) = sol(s, idxs = sys.θ)
        θ(s::AbstractVector{<:Real}) = sol(s, idxs = sys.θ) |> collect

        p(s::Real) = sol(s, idxs = sys.p_re) + im * sol(s, idxs = sys.p_im)
        p(s::AbstractVector{<:Real}) = sol(s, idxs = sys.p_re) + im * sol(s, idxs = sys.p_im) |> collect
        q(s::Real) = sol(s, idxs = sys.q_re) + im * sol(s, idxs = sys.q_im)
        q(s::AbstractVector{<:Real}) = sol(s, idxs = sys.q_re) + im * sol(s, idxs = sys.q_im) |> collect

        new(model, sol.t[end], f, r, z, ξ, ζ, A, φ, τ, p, q, c, θ, sol)
    end
end

show(io::IO, beam::Beam) = show(io, "Beam($(beam.θ(0) |> rad2deg)°)")

function (beam::Beam)(::Val{:pressure}, s::S, n::N = 0.0) where {
    S <: Union{<:Real, <:AbstractVector{<:Real}},
    N <: Union{<:Real, <:AbstractArray{<:Real}}
}
    beam_pressure(beam.model, s, n;
        (
            var => getproperty(beam, var)
            for var in (:c, :f, :r, :A, :φ, :τ, :p, :q, :θ)
        )...
    )
end

function (beam::Beam)(::Val{:propagation_loss}, s::S, n::N = 0.0) where {
    S <: Union{<:Real, <:AbstractVector{<:Real}},
    N <: Union{<:Real, <:AbstractArray{<:Real}}
}
    -20(beam(:pressure |> Val, s, n) .|> abs .|> log10)
end

function (beam::Beam)(s::S, n::N = 0.0) where {
    S <: Union{<:Real, <:AbstractVector{<:Real}},
    N <: Union{<:Real, <:AbstractArray{<:Real}}
}
    beam(:pressure |> Val, s, n)
end

function (beam::Beam)(property::Union{Symbol, <:AbstractString}, s::S, n::N = 0.0) where {
    S <: Union{<:Real, <:AbstractVector{<:Real}},
    N <: Union{<:Real, <:AbstractArray{<:Real}}
}
    beam(property |> modelval, s, n)
end