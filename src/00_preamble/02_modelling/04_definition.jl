macro implement_model_function(function_name)
    function_type_name = Symbol(pascaltext(function_name) * "FunctionType")

    @eval begin
        struct $function_type_name <: ModelFunction end
        const $function_name = $function_type_name()
    end
end
