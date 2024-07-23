export OceanCelerity

@implement_modelling_functor ModellingFunctor3D OceanCelerity

function OceanCelerity(::ModelName{:munk}, x::Real, y::Real, z::Real; ϵ::Real = 7.37e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

function OceanCelerity(::ModelName{:square_index}, x::Real, y::Real, z::Real; c₀ = 1550.0)
    c₀ / ocnson_sqrt(1 + 2.4z / c₀)
end