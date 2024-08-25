export ocean_celerity
export OceanCelerity

@implement_modelling ocean_celerity 3

ocean_celerity(::Val{:homogeneous}, x::Real, y::Real, z::Real) = 1500.0

function ocean_celerity(::Val{:munk}, x::Real, y::Real, z::Real; ϵ::Real = 7.37e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

function ocean_celerity(::Val{:square_index},
    x::Real, y::Real, z::Real;
    c₀ = 1550.0
)
    c₀ / ocnson_sqrt(1 + 2.4z / c₀)
end
