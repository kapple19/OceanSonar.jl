struct ModelFunction <: Function end

const ocean_celerity = ModelFunction()

ocean_celerity(::Val{:homogeneous}, z::Real) = 1500.0

ocean_celerity(::Val{:munk}, z::Real; ϵ = 7.37e-3) = begin
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

# Errors
function ocean_celerity(::Val{:munk}, z::Real; ϵ = 7.37e-3)
    ϵ::Real
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

abstract type Functor <: Function end

struct ModelFunctor <: Functor
    model_function::ModelFunction
    model::Val
end

cel = ModelFunctor(ocean_celerity, :munk |> Val)

(model_functor::ModelFunctor)(z) = model_functor.model_function(model_functor.model, z)
