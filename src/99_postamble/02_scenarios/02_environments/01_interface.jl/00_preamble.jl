export Interface

@kwdef mutable struct Interface <: ModelContainer
    z::DepthFunctionProfileType where {DepthFunctionProfileType <: Function}
    R::ReflectionCoefficientProfileFunctionType where {ReflectionCoefficientProfileFunctionType <: Function}
end
