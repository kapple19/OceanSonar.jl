macro implement_modelling(modelling_function_sym, D)
    modelling_function_str = modelling_function_sym |> String

    modelling_function_type_str = modelling_function_str * "_type"
    modelling_function_type_sym = modelling_function_type_str |> Symbol

    modelling_functor_str = modelling_function_str |> pascalcase
    modelling_functor_sym = modelling_functor_str |> Symbol

    (single_var_sym, first_var_sym, second_var_sym) = if D == 2
        :r, :x, :y
    elseif D == 3
        :z, :r, :z
    else
        error("Dimension size must be 2 or 3.")
    end

    @eval begin
        struct $modelling_function_type_sym <: ModellingFunction{$D} end

        const $modelling_function_sym = $modelling_function_type_sym()

        $modelling_function_sym(model::Union{Symbol, <:AbstractString}, args...; kw...) = $modelling_function_sym(model |> modelval, args...; kw...)

        ModellingFunction(::Type{$modelling_function_type_sym}) = $modelling_function_sym

        struct $modelling_functor_sym <: ModellingFunctor{$D}
            model::Val
            orienter::Orienter{$D}
            pars::Pairs

            function $modelling_functor_sym(
                model::Val,
                x₀::Real = 0.0, y₀::Real = 0.0, θ::Real = 0.0;
                pars...
            )
                orienter = Orienter{$D}(x₀, y₀, θ)
                new(model, orienter, pars)
            end
        end

        (modelling_functor::$modelling_functor_sym)($single_var_sym::Real) = $modelling_function_sym(
            modelling_functor.model,
            modelling_functor.orienter($single_var_sym)...;
            modelling_functor.pars...
        )

        (modelling_functor::$modelling_functor_sym)($first_var_sym::Real, $second_var_sym::Real) = $modelling_function_sym(
            modelling_functor.model,
            modelling_functor.orienter($first_var_sym, $second_var_sym)...;
            modelling_functor.pars...
        )
    end

    if D == 3
        @eval begin
            (modelling_functor::$modelling_functor_sym)(x::Real, y::Real, z::Real) = $modelling_function_sym(
                modelling_functor.model,
                modelling_functor.orienter(x, y, z)...;
                modelling_functor.pars...
            )
        end
    end

    @eval begin
        $modelling_functor_sym(model::Union{Symbol, String}, args...; kw...) = $modelling_functor_sym(model |> modelval, args...; kw...)

        ModellingFunction(::Type{$modelling_functor_sym}) = $modelling_function_sym
        ModellingFunctor(::Type{$modelling_function_type_sym}) = $modelling_functor_sym
        ModellingFunctor(::Type{$modelling_function_sym}) = $modelling_functor_sym
    end

    if D == 2
        @eval begin
            @register_symbolic $modelling_function_sym(x, y)
        end
    elseif D == 3
        @eval begin
            @register_symbolic $modelling_function_sym(x, y, z)
        end
    end
end