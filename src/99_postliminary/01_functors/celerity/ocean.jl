export ocean_celerity_profile
export OceanCelerityProfile

@implement_spatially_modelled_function_and_functor OceanCelerityProfile 3

ocean_celerity_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 1500.0)::Real = c

function ocean_celerity_profile(::ModelName{:Munk}, x::Real, y::Real, z::Real; ϵ = 7.47e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end