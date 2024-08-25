export listmodels

abstract type AbstractModellingType <: Function end

abstract type ModellingFunction{N} <: AbstractModellingType end
abstract type ModellingFunctor{N} <: AbstractModellingType end

function String(modelling_function::ModellingFunction)
    str = modelling_function |> string |> extract_last_underscored_alphanumeric_bodies
    ending = "_type"
    endswith(str, ending) && return str[1 : end-length(ending)]
    return str
end

function String(modelling_functor::Type{<:ModellingFunctor})
    modelling_functor |> string |> extract_first_underscored_alphanumeric_bodies
end

Symbol(modelling_function::ModellingFunction) = modelling_function |> String |> Symbol
Symbol(modelling_functor::ModellingFunctor) = modelling_functor |> String |> Symbol

ModellingFunction(modelling_functor::ModellingFunctor) = getproperty(OceanSonar, modelling_functor |> String |> snakecase |> Symbol)
ModellingFunctor(modelling_function::ModellingFunction) = getproperty(OceanSonar, modelling_function |> String |> pascalcase |> Symbol)

modelpretty(ModellingType::Type{<:AbstractModellingType}, model) = modelpretty(ModellingType, model)
modelpretty(modelling_instance::AbstractModellingType, model::Union{Val, Symbol}) = modelpretty(modelling_instance, model |> modelsnake)
modelpretty(::AbstractModellingType, model::AbstractString) = model |> titlecase

listmodels(modelling_function::ModellingFunction) = [
    modelpretty(modelling_function, type())
    for type in [
        collect(m.sig.types)[2] for m in methods(modelling_function)
    ] if type <: Val
]

listmodels(modelling_functor::Type{<:ModellingFunctor}) = modelling_functor |> ModellingFunction |> listmodels