export String
export Symbol
export Function
export Functor

abstract type ModelFunction <: Function end
abstract type ModelFunction2D <: ModelFunction end
abstract type ModelFunction3D <: ModelFunction end
abstract type Functor <: Function end
abstract type ModelFunctor <: Functor end
abstract type ModelFunctor2D <: ModelFunctor end
abstract type ModelFunctor3D <: ModelFunctor end

function String(ModelType::Union{Type{<:ModelFunction}, Type{<:ModelFunctor}})
    ModelType |> string |> extract_after_last_period
end

function Symbol(ModelType::Union{Type{<:ModelFunction}, Type{<:ModelFunctor}})
    ModelType |> string |> Symbol
end

function Function(ModelFunctorType::Type{<:ModelFunctor})
    getproperty(OceanSonar, ModelFunctorType |> String |> snakecase |> Symbol)
end

function Functor(ModelFunctorType::Type{<:ModelFunction})
    getproperty(OceanSonar, ModelFunctorType |> String |> pascalcase |> Symbol)
end
