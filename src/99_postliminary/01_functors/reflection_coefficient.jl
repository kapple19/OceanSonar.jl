export reflection_coefficient_profile
export ReflectionCoefficientProfile

@implement_spatially_modelled_function_and_functor ReflectionCoefficientProfile 2

function (FunctorType::Type{<:ReflectionCoefficientProfile})(
    SDS::SpatialDimensionSize,
    model::ModelName{M},
    x₀::Real = 0.0,
    y₀::Real = 0.0,
    θ::Real = 0.0;
    pars...
) where {M}
    modelling_function = ModellingFunction(FunctorType)
    profile(r::Real, φ::Real) = modelling_function(model, orienter(SDS, r; x₀ = x₀, y₀ = y₀, θ = θ)..., φ; pars...)
    profile(x::Real, y::Real, φ::Real) = modelling_function(model, orienter(SDS, x, y; x₀ = x₀, y₀ = y₀, θ = θ)..., φ; pars...)
    FunctorType{profile |> typeof}(profile)
end

## Models
reflection_coefficient_profile(::ModelName{:Mirror}, x::Real, y::Real, φ::Real) = ComplexF64(-1.0)
reflection_coefficient_profile(::ModelName{:Absorbent}, x::Real, y::Real, φ::Real) = ComplexF64(0.0)
reflection_coefficient_profile(::ModelName{:Reflective}, x::Real, y::Real, φ::Real) = ComplexF64(1.0)
