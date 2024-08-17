## Models
# function beam_pressure(::ModelName{:Ray}, )

# end

function beam_pressure(::ModelName{:Gaussian},
    n::Real,
    f::Real,
    c₀::Real,
    φ₀::Real,
    q₀::Real,
    c::Union{<:Real, <:AbstractArray{<:Real}},
    r::Union{<:Real, <:AbstractArray{<:Real}},
    A::Union{<:Real, <:AbstractArray{<:Real}},
    ϕ::Union{<:Real, <:AbstractArray{<:Real}},
    τ::Union{<:Real, <:AbstractArray{<:Real}},
    p::Union{<:Real, <:AbstractArray{<:Real}},
    q::Union{<:Real, <:AbstractArray{<:Real}},
    φ::Union{<:Real, <:AbstractArray{<:Real}}
)
    return @. complex(A, ϕ) * sqrt(
        c / (r * q) * q₀ * f * cos(φ₀)
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
    ϕ::Function,
    τ::Function,
    p::Function,
    q::Function,
    φ::Function
) where {
    Model <: ModelName,
    ArcLengthType <: Union{<:Real, <:AbstractVector{<:Real}},
    NormalDisplacementType <: Union{<:Real, <:AbstractArray{<:Real}}
}
    c′ = c(s)
    r′ = r(s)
    A′ = A(s)
    ϕ′ = ϕ(s)
    p′ = p(s)
    q′ = q(s)
    τ′ = τ(s)

    return @. beam_pressure(model, 
        n, f,
        c(0), φ(0), q(0),
        c(s), r(s), A(s), ϕ(s), τ(s), p(s), q(s), φ(s)
    )
end
