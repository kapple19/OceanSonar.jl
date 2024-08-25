export list_models
export parameters

list_models(ModelFunctionType::Type{<:ModelFunction}) = [
    modelpresentation(ModelFunctionType, type())
    for type in [
        collect(m.sig.types)[2] for m in methods(ModelFunctionType)
    ] if type <: Val
]

modelpresentation(::Type{<:ModelFunction}, ::Val{M}) where M = modeltitle(M)

function parameters(ModelFunctionType::Type{<:ModelFunction}, model::Val{M}) where M
    m = methodswith(model |> typeof, ModelFunctionType) |> only
    sig = signature(m)
    haskey(sig, :kwargs) && return sig[:kwargs] |> Tuple
    return tuple()
end

function parameters(ModelFunctionType::Type{<:ModelFunction}, model::Union{Symbol, String})
    parameters(ModelFunctionType, model |> modelval)
end

function parameters(ModelFunctorType::Type{<:ModelFunctor}, model::Union{Val, Symbol, String})
    parameters(ModelFunctorType |> Function, model |> modelval)
end

function list_models(ModelFunctorType::Type{<:ModelFunctor})
    ModelFunctorType |> Function |> list_models
end
