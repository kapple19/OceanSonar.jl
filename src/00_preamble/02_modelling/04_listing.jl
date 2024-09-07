export listmodels
export listarguments

ModelTypeOrInstance = Union{ModelFunction, Type{<:ModelFunction}}

function listmodels(::Type{Model}, fcn::ModelTypeOrInstance)
    meths = methods(fcn)
    first_arg_types = [
        meth.sig.types[2]
        for meth in meths
        if length(meth.sig.types) >= 2
    ]
    return [
        type()
        for type in first_arg_types
        if type <: Model
    ]
end

listmodels(::Type{Symbol}, fcn::ModelTypeOrInstance) = listmodels(Model, fcn) .|> Symbol
listmodels(::Type{String}, fcn::ModelTypeOrInstance) = listmodels(Model, fcn) .|> String
listmodels(fcn::ModelTypeOrInstance) = listmodels(Model, fcn) .|> titletext

function listarguments(fcn::ModelTypeOrInstance, model::Model)
    @assert model in listmodels(Model, fcn)
    meths = methodswith(model |> typeof, fcn)
    inpss = @. method_argnames(meths)
    parss = @. kwarg_decl(meths)
    return [
        (
            inputs = length(inps) >= 3 ? inps[3:end] : Symbol[],
            parameters = pars[1:end]
        )
        for (inps, pars) in zip(inpss, parss)
    ]
end

function listarguments(fcn::ModelTypeOrInstance, model::Union{Symbol, <:AbstractString})
    listarguments(fcn, model |> Model)
end
