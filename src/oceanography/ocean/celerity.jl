export ocean_celerity
export OceanCelerity

ocean_celerity(::Val{:homogeneous}, ::Real, ::Real) = 1500.0

function ocean_celerity(::Val{:munk}, ::Real, z::Real)
    ϵ = 7.37e-3
    z̃ = 2(z/1300 - 1)
    c = 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

function ocean_celerity(::Val{:index_squared}, ::Real, z::Real)
    c₀ = 1550.0
    shallowest = -c₀/2.4
    # ẑ = max(z, shallowest)
    # c₀ / sqrt(1 + 2.4ẑ / c₀)
    c₀ / NaNMath.sqrt(1 + 2.4z / c₀)
end

@add_model_conversion_methods ocean_celerity

OceanCelerity() = Celerity{:ocean}()
OceanCelerity(model) = Celerity{:ocean}(model)

function (cel::Celerity{:ocean})(args...; kwargs...)
    ocean_celerity(cel.model, args...; kwargs...)
end