export reflection_coefficient
export ReflectionCoefficient

# TODO: Add range dependence - amalgamating models sequentially or interpolatedly

reflection_coefficient(::Val{:mirror}, θ::Real) = complex(-1.0)
reflection_coefficient(::Val{:absorbent}, θ::Real) = complex(0.0)
reflection_coefficient(::Val{:reflective}, θ::Real) = complex(1.0)

struct ReflectionCoefficient <: Function
    model::Val
end

(rfl_coef::ReflectionCoefficient)(θ::Real) = reflection_coefficient(rfl_coef.model, θ)

ReflectionCoefficient(model::Union{Symbol, <:AbstractString}) = model |> modelval |> ReflectionCoefficient
