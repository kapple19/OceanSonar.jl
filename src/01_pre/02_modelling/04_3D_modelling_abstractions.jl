macro implement_3D_modelling(model_function_sym)
    model_function_name = esc(model_function_sym)
    model_functor_sym = model_function_sym |> String |> pascalcase |> Symbol
    model_functor_name = esc(model_functor_sym)

    quote
        abstract type $model_function_name <: ModelFunction3D end

        function $model_function_name(model::Union{Symbol, String}, x::Real, y::Real, z::Real; pars...)
            $model_function_name(model |> modelval, x, y, z ; pars...)
        end

        struct $model_functor_name{D} <: ModelFunctor3D
            model::Val
            pars::Pairs
            slicer::Slicer3D{D}
    
            function $model_functor_name{1}(model::Val, x₀::Real = 0.0, y₀::Real = 0.0; pars...)
                model_present = modelpresentation($model_function_name, model)
                if model_present ∉ list_models($model_function_name)
                    error("Invalid ", $model_functor_name, " model: ", model_present, ".")
                end
                slicer = Slicer3D{1}(x₀, y₀)
                new(model, pars, slicer)
            end

            function $model_functor_name{2}(model::Val, x₀::Real = 0.0, y₀::Real = 0.0, θ::Real = 0.0; pars...)
                model_present = modelpresentation($model_function_name, model)
                if model_present ∉ list_models($model_function_name)
                    error("Invalid ", $model_functor_name, " model: ", model_present, ".")
                end
                slicer = Slicer3D{2}(x₀, y₀, θ)
                new(model, pars, slicer)
            end
        
            function $model_functor_name{3}(model::Val, x₀::Real = 0.0, y₀::Real = 0.0, θ::Real = 0.0; pars...)
                model_present = modelpresentation($model_function_name, model)
                if model_present ∉ list_models($model_function_name)
                    error("Invalid ", $model_functor_name, " model: ", model_present, ".")
                end
                slicer = Slicer3D{2}(x₀, y₀, θ)
                new(model, pars)
            end
        end

        function $model_functor_name{D}(model::Union{Symbol, <:AbstractString}, args...; pars...) where D
            $model_functor_name{D}(model |> modelval, args...; pars...)
        end

        function (inst::$model_functor_name{1})(z::Real)
            $model_function_name(inst.model, inst.slicer()..., z; inst.pars...)
        end

        function (inst::$model_functor_name{2})(r::Real, z::Real)
            $model_function_name(inst.model, inst.slicer(r)..., z; inst.pars...)
        end

        function (inst::$model_functor_name{3})(x::Real, y::Real, z::Real)
            $model_function_name(inst.model, inst.slicer(x, y)..., z; inst.pars...)
        end
    end
end