function (ModelFunctionType::Type{<:ModelFunction})(model::Union{Symbol, <:AbstractString}, args...; kws...)
    ModelFunctionType(model |> Model, args...; kws...)
end

function (fcn::ModelFunction)(model::Union{Symbol, <:AbstractString}, args...; kws...)
    fcn(model |> Model, args...; kws...)
end
