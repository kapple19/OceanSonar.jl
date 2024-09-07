macro implement_model_function(fcn_name)
    fcn_type_name = Symbol(pascaltext(fcn_name |> String) * "ModelFunctionType")

    @eval begin
        struct $fcn_type_name <: ModelFunction end
        const $fcn_name = $fcn_type_name()
    end
end