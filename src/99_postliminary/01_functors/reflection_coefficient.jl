export reflection_coefficient_profile
export ReflectionCoefficientProfile

struct ReflectionCoefficientProfileType <: ModellingFunction end
const reflection_coefficient_profile = ReflectionCoefficientProfileType()

struct ReflectionCoefficientProfile{ProfileFunctionType <: Function} <: ModellingFunctor
    profile::ProfileFunctionType
end

EnvironmentComponent(::ReflectionCoefficientProfileType) = GenericOceanInterface()
ModellingFunction(::Type{<:ReflectionCoefficientProfile}) = reflection_coefficient_profile

function (FunctorType::Type{<:ReflectionCoefficientProfile})(
    EC::GenericOceanInterface,
    model::ModelName{M},
    x₀::Real = 0.0,
    y₀::Real = 0.0,
    θ₀::Real = 0.0;
    pars...
) where {M}
    modelling_function = ModellingFunction(FunctorType)
    profile(r::Real, θ::Real) = modelling_function(model, orienter(EC, r; x₀ = x₀, y₀ = y₀, θ = θ₀)..., θ; pars...)
    profile(x::Real, y::Real, θ::Real) = modelling_function(model, orienter(ED, x, y; x₀ = x₀, y₀ = y₀, θ = θ₀)..., θ; pars...)
    FunctorType{profile |> typeof}(profile)
end

## Models
reflection_coefficient_profile(::ModelName{:Mirror}, x::Real, y::Real, θ::Real) = ComplexF64(-1.0)
reflection_coefficient_profile(::ModelName{:Absorbent}, x::Real, y::Real, θ::Real) = ComplexF64(0.0)
reflection_coefficient_profile(::ModelName{:Reflective}, x::Real, y::Real, θ::Real) = ComplexF64(1.0)
