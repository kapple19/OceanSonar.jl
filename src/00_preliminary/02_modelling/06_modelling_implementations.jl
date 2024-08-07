macro implement_generic_modelling_function(function_name)
    function_type_name = Symbol(pascaltext(function_name) * "Type")
    @eval begin
        struct $function_type_name <: ModellingFunction end
        const $function_name = $function_type_name()
    end
end

macro implement_environment_function_and_functor(environment_component_name, parameter_name)
    functor_name_string = string(environment_component_name, parameter_name, "Profile")
    functor_name = Symbol(functor_name_string)
    function_name = Symbol(functor_name_string |> snaketext)
    function_type_name = Symbol(functor_name_string * "Type")

    @eval begin
        struct $function_type_name <: ModellingFunction end
        const $function_name = $function_type_name()

        struct $functor_name{ProfileFunctionType <: Function} <: ModellingFunctor
            profile::ProfileFunctionType
        end

        EnvironmentComponent(::$function_type_name) = $environment_component_name()
        ModellingFunction(::Type{<:$functor_name}) = $function_name
    end
end
