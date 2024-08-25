macro add_model_conversion_methods(fun_name_sym::Symbol)
    fun_name = esc(fun_name_sym)
    quote
        function $fun_name(model::String, args...; kwargs...)
            $fun_name(model |> snakecase |> Symbol, args...; kwargs...)
        end

        function $fun_name(model::Symbol, args...; kwargs...)
            $fun_name(model |> Val, args...; kwargs...)
        end
    end
end