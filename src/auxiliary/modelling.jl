export list_models
export val2model
export val2snake
export val2sym

val2sym(::Val{T}) where {T} = T

val2snake(val::Val) = val |> val2sym |> string |> snakecase

val2model(val::Val) = val |> val2sym |> string |> spacecase |> titlecase

"""
```
models::Vector{<:Val} = list_models(
    func::Union{
        Function,
        Type{<:OcnSonContainer},
        Type{<:OcnSonHybrid}
    }
)
```
"""
function list_models(
    func::Union{Function, Type{<:OcnSonContainer}, Type{<:OcnSonHybrid}}
)
    @assert parentmodule(func) == OceanSonar "`list_models` only for OceanSonar.jl objects."

	func_methods = methods(func)
	func_sigs = [func_method.sig for func_method in func_methods]
	func_pars = [func_sig.parameters for func_sig in func_sigs]
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
	return [
        func_val[1]()
        for func_val in func_vals
        if condition(func_val)
    ]
end

function doc_models(func::Union{Function, Type{<:OcnSon}})
    parentmodule(func) ≠ OceanSonar && error("`doc_models` only defined for `OceanSonar.jl` definitions.")
    [
        "* `\"" * string(model) * "\"`\n" for model in list_models(func)
    ] |> join
end

macro parse_models_and_arguments(func_name_sym::Symbol)
    name = esc(func_name_sym)
    quote
        function $name(model::Val, args...; kwargs...)
            error(
                "No ", $name, " implementation for ", model, ".",
                " Feel free to implement your own, otherwise check spelling: ",
                "existing models are: ", list_models($name)
            )
        end
    end
end

macro parse_models(con_name_sym::Symbol)
    name = esc(con_name_sym)
    quote
        function $name(model::Val{Symbol()})
            error("Default ", $name, " is intentionally invalid.")
        end

        function $name(model::Val)
            error(
                "No ", $name, " implementation for ", model, ".",
                " Feel free to implement your own, otherwise check spelling: ",
                "existing models are: ", list_models($name)
            )
        end
    end
end