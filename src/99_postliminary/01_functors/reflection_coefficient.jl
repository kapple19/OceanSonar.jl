export reflection_coefficient_profile
export ReflectionCoefficientProfile

@implement_environment_function_and_functor ReflectionCoefficient

reflection_coefficient_profile(::Val{:Mirror}, θ::Real) = ComplexF64(-1.0)
reflection_coefficient_profile(::Val{:Absorbent}, θ::Real) = ComplexF64(0.0)
reflection_coefficient_profile(::Val{:Reflective}, θ::Real) = ComplexF64(1.0)
