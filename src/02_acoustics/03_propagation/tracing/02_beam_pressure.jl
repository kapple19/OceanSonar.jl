## Models
# function beam_pressure(::Val{:Ray}, )

# end

function beam_pressure(::Val{:Gaussian},
    n::Real,
    f::Real,
    c₀::Real,
    θ₀::Real,
    q₀::Real,
    c::Union{<:Real, <:AbstractArray{<:Real}},
    r::Union{<:Real, <:AbstractArray{<:Real}},
    A::Union{<:Real, <:AbstractArray{<:Real}},
    φ::Union{<:Real, <:AbstractArray{<:Real}},
    τ::Union{<:Real, <:AbstractArray{<:Real}},
    p::Union{<:Real, <:AbstractArray{<:Real}},
    q::Union{<:Real, <:AbstractArray{<:Real}},
    θ::Union{<:Real, <:AbstractArray{<:Real}}
)
    return @. complex(A, φ) * sqrt(
        c / (r * q) * q₀ * f * cos(θ₀)
    ) * cispi(
        -2f * (
            τ + p * n^2 / 2q
        ) / 4
    ) / c₀
end

# function beam_pressure(::ModelName{:Hat}, )

# end

## Generic
function beam_pressure(model::Model, s::ArcLengthType, n::NormalDisplacementType = 0.0;
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
    Model <: ModelName,
    ArcLengthType <: Union{<:Real, <:AbstractVector{<:Real}},
    NormalDisplacementType <: Union{<:Real, <:AbstractArray{<:Real}}
}
    c′ = c(s)
    r′ = r(s)
    A′ = A(s)
    φ′ = φ(s)
    p′ = p(s)
    q′ = q(s)
    τ′ = τ(s)

    return @. beam_pressure(model, 
        n, f,
        c(0), θ(0), q(0),
        c(s), r(s), A(s), φ(s), τ(s), p(s), q(s), θ(s)
    )
end
