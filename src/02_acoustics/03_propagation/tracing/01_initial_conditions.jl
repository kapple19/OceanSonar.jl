const DEFAULT_BEAM_WIDTH_WAVELENGTH_MULTIPLIER = 30

## Models
# function beam_initial_conditions(::ModelName{:Ray},
#     f, θ₀, r₀, z₀, c₀;
#     M = DEFAULT_BEAM_WIDTH_WAVELENGTH_MULTIPLIER
# )

# end

function beam_initial_conditions(::ModelName{:Gaussian},
    f, θ₀, r₀, z₀, c₀;
    M = DEFAULT_BEAM_WIDTH_WAVELENGTH_MULTIPLIER
)
    ω = 2π * f

    ξ₀, ζ₀ = cossin(θ₀) ./ c₀
    λ₀ = c₀ / f
    W₀ = M * λ₀
    p₀ = 1.0 + 0.0im
    q₀ = 0.5im * ω * W₀^2

    return ξ₀, ζ₀, p₀, q₀
end

# function beam_initial_conditions(::ModelName{:Hat},
#     f, θ₀, r₀, z₀, c₀;
#     M = DEFAULT_BEAM_WIDTH_WAVELENGTH_MULTIPLIER
# )

# end

## Generic
function beam_initial_conditions(model::Model) where {Model <: ModelName}
    θ₀::Real, f::Real, r₀::Real, z₀::Real, c₀::Real,
    ξ₀::Num, ζ₀::Num, p₀::Num, q₀::Num;
    M::Real = DEFAULT_BEAM_WIDTH_WAVELENGTH_MULTIPLIER

    return [ξ₀, ζ₀, p₀, q₀] .=> beam_initial_conditions(model, f, θ₀, r₀, z₀, c₀; M = M)
end
