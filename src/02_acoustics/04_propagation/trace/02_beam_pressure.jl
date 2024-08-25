function beam_pressure(::Val{:gaussian}, s::S, n::N = 0.0;
    f::Real,
    c::Function,
    r::Function,
    A::Function,
    φ::Function,
    τ::Function,
    p::Function,
    q::Function,
    θ::Function
) where {
    S <: Union{<:Real, <:AbstractVector{<:Real}},
    N <: Union{<:Real, <:AbstractArray{<:Real}}
}
    c′ = c(s)
    r′ = r(s)
    A′ = A(s)
    φ′ = φ(s)
    p′ = p(s)
    q′ = q(s)
    τ′ = τ(s)

    return @. complex(A′, φ′) * sqrt(
        c′ / (r′ * q′) * q(0) * f * cos(θ(0))
    ) * cispi(
        -2f * (
            τ′ + p′ * n^2 / 2q′
        ) / 4
    ) / $c(0)
end