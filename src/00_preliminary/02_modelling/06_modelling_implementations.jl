macro implement_generic_modelling_function(function_name)
    function_type_name = Symbol(pascaltext(function_name) * "Type")
    @eval begin
        struct $function_type_name <: ModellingFunction end
        const $function_name = $function_type_name()
    end
end

macro implement_spatially_modelled_function_and_functor(functor_name, spatial_dimension)
    function_name = Symbol(functor_name |> string |> snaketext)
    function_type_name = string(functor_name, "Type") |> Symbol

    @eval begin
        struct $function_type_name <: ModellingFunction end
        const $function_name = $function_type_name()

        struct $functor_name{ProfileFunctionType <: Function} <: ModellingFunctor
            profile::ProfileFunctionType
        end

        SpatialDimensionSize(::$function_type_name) = SpatialDimensionSize{$spatial_dimension}()
        ModellingFunction(::Type{<:$functor_name}) = $function_name
    end
end
