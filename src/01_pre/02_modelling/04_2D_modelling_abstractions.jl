macro implement_2D_modelling(model_function_sym)
    model_function_name = esc(model_function_sym)
    model_functor_sym = model_function_sym |> String |> pascalcase |> Symbol
    model_functor_name = esc(model_functor_sym)

    quote
        abstract type $model_function_name <: ModelFunction2D end

        function $model_function_name(model::Union{Symbol, String}, args...; pars...)
            $model_function_name(model |> modelval, args... ; pars...)
        end

        struct $model_functor_name{D} <: ModelFunctor2D
            model::Val
            pars::Pairs
            slicer::Slicer2D{D}

            function $model_functor_name{D}(model::Val, x₀::Real = 0.0, y₀::Real = 0.0, θ::Real = 0.0; pars...) where D
                model_present = modelpresentation($model_function_name, model)
                if model_present ∉ list_models($model_function_name)
                    error("Invalid ", $model_functor_name, " model: ", model_present, ".")
                end
                slicer = Slicer2D{D}(x₀, y₀, θ)
                new(model, pars, slicer)
            end
        end

        function $model_functor_name{D}(model::Union{Symbol, <:AbstractString}, args...; pars...) where D
            $model_functor_name{D}(model |> modelval, args...; pars...)
        end

        function (inst::$model_functor_name{1})(r::Real)
            $model_function_name(inst.model, inst.slicer(r)...; inst.pars...)
        end

        function (inst::$model_functor_name{2})(x::Real, y::Real)
            $model_function_name(inst.model, inst.slicer(x, y)...; inst.pars...)
        end
    end
end