export reflection_coefficient_profile

@implement_model_function reflection_coefficient_profile

reflection_coefficient_profile(::Model{:Homogeneous}, x::Real, y::Real; A::Real, ϕ::Real) = A * cis(ϕ)

reflection_coefficient_profile(::Model{:Mirror}, x::Real, y::Real) =
    reflection_coefficient_profile(:Homogeneous, x, y; A = 1.0, ϕ = π)

reflection_coefficient_profile(::Model{:Reflective}, x::Real, y::Real) =
    reflection_coefficient_profile(:Homogeneous, x, y; A = 1.0, ϕ = 0.0)

reflection_coefficient_profile(::Model{:Translucent}, x::Real, y::Real; A::Real = 0.5, ϕ::Real = 0.0) = 
    reflection_coefficient_profile(:Homogeneous, x, y; A = A, ϕ = ϕ)

reflection_coefficient_profile(::Model{:Absorbent}, x::Real, y::Real) = Complex(0.0)
