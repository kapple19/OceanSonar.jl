export list_models
export list_inputs
export modelsnake
export modelsymbol
export modeltitle

"""
`modelsnake(model::Union{String, Symbol, Val})`

Converts `model` as a `String`, `Symbol`, or `Val`
into a snake-case `String` for `OceanSonar` model parsing.
"""
function modelsnake end
modelsnake(model::String) = model |> snake_case
modelsnake(model::Symbol) = model |> string |> modelsnake
modelsnake(::Val{model}) where model = model |> modelsnake

"""
`modelsymbol(model::Union{String, Symbol, Val})`

Converts `model` as a `String`, `Symbol`, or `Val`
into a `Symbol` for `OceanSonar` model parsing.
"""
function modelsymbol(model::Union{String, Symbol, Val})
    model |> modelsnake |> Symbol
end

"""
`modelval(model::Union{String, Symbol, Val})`

Converts `model` as a `String`, `Symbol`, or `Val`
into a `Val` for `OceanSonar` model parsing.
"""
function modelval(model::Union{String, Symbol, Val})
    model |> modelsymbol |> Val
end

"""
`modeltitle(model::Union{String, Symbol, Val})`

Converts `model` as a `String`, `Symbol`, or `Val`
into a title-case `String` for `OceanSonar` model parsing.
"""
function modeltitle(model::Union{String, Symbol, Val})
    model |> modelsnake |> title_case
end

function list_model_symbols(
    func::Union{Function, Type{<:OcnSon}}
)
    @assert parentmodule(func) == OceanSonar "`list_models` only for OceanSonar.jl objects."

	func_methods = methods(func)
    func_sigs = [func_method.sig for func_method in func_methods]
    func_pars = [
        func_sig.parameters
        for func_sig in func_sigs
        if hasproperty(func_sig, :parameters)
    ]
    func_vals = [
        [
            par
            for par in func_par
            if par isa Type && par <: Val
        ] for func_par in func_pars
    ]
	for func_val in func_vals
		if length(func_val) > 1
			error(func, " method has more than one `Val` specification: ", func_val...)
		end
	end
    condition(func_val) = length(func_val) == 1 && func_val[1] ≠ Val && func_val[1] ≠ Val{Symbol("")}
	func_vals2 = [
        func_val[1]()
        for func_val in func_vals
        if condition(func_val)
    ]
    return func_vals2 .|> modelsymbol |> unique
end

"""
```
models::Symbol = list_models(
    func::Union{
        Function,
        Type{<:Container},
        Type{<:Result}
    }
)
```
"""
list_models(func::Union{Function, Type{<:OcnSon}}) = list_model_symbols(func) .|> modeltitle

function doc_models(func::Union{Function, Type{<:OcnSon}})
    parentmodule(func) ≠ OceanSonar && error("`doc_models` only defined for `OceanSonar.jl` definitions.")
    return [
        "* `\"" * string(model) * "\"`\n" for model in list_models(func)
    ] |> join
end

function list_inputs(func, model::Val)
	func_methods = [
		func_method
		for func_method in methods(func)
		if typeof(model) in func_method.sig.parameters
	]
	func_method = func_methods[1] # will fix later
	return Base.method_argnames(func_method)[3:end]
end

list_inputs(func) = list_inputs(func, func.model)

list_inputs(func, model::Symbol) = list_inputs(func, model |> Val)

macro parse_models(con_name_sym::Symbol)
    name = esc(con_name_sym)
    quote
        function $name(model::Val{Symbol()})
            error("Default ", $name, " is intentionally invalid.")
        end

        function $name(model::Union{Symbol, String})
            $name(model |> modelval)
        end
    end
end

macro parse_models_w_args(func_name_sym::Symbol)
    name = esc(func_name_sym)
    quote
        function $name(model::Union{Symbol, String}, args...)
            $name(model |> modelval, args...)
        end
    end
end

macro parse_models_w_args_kwargs(func_name_sym::Symbol)
    name = esc(func_name_sym)
    quote
        function $name(model::Union{Symbol, String}, args...; kwargs...)
            $name(model |> modelval, args...; kwargs...)
        end
    end
end