listmodels(modelling_function::AbstractModellingType) = [
    modelpretty(modelling_function, type())
    for type in [
        collect(m.sig.types)[2] for m in methods(modelling_function)
    ] if type <: ModelName
]

listmodels(fct::Fct) where {Fct<:ModellingFunctor} = String(Fct)