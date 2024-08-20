export listmodels
export listarguments

function listmodels(::Type{Model}, fcn::MetricFunction)
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

listmodels(::Type{Symbol}, fcn::MetricFunction) = listmodels(Model, fcn) .|> Symbol
listmodels(::Type{String}, fcn::MetricFunction) = listmodels(Model, fcn) .|> String

"""
```
listmodels(fcn::MetricFunction)
```

Returns the names of `fcn` models as a `Vector` of `String`s formatted with `titletext`.

Each element of the output can be used as the first positional argument to `fcn`.

See also: [`listarguments`](@ref), [`Model`](@ref), [`OceanSonar.MetricFunction`](@ref).
"""
listmodels(fcn::MetricFunction) = listmodels(Model, fcn) .|> titletext

"""
```
listarguments(fcn::MetricFunction, model::String)
listarguments(fcn::MetricFunction, model::Symbol)
listarguments(fcn::MetricFunction, model::Model)
```

Lists the inputs (positional arguments) and parameters (keyword arguments)
of `fcn` for the `model` specified as a `Vector` of `NamedTuple`s
with fields `inputs` and `parameters`.

While `InteractiveUtils.methodswith` gives similar information,
`listarguments` provides the argument names in a useable form.
"""
function listarguments(fcn::MetricFunction, model::Model)
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

function listarguments(fcn::MetricFunction, model::Union{Symbol, <:AbstractString})
    listarguments(fcn, model |> Model)
end
