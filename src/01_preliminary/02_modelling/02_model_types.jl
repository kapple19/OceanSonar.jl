abstract type AbstractModellingType <: Function end
abstract type ModellingFunction <: AbstractModellingType end
abstract type ModellingFunctor <: AbstractModellingType end
abstract type ModellingFunctor2D <: ModellingFunctor end
abstract type ModellingFunctor3D <: ModellingFunctor end

function (::Type{Fun})(
    model::Union{Symbol, <:AbstractString}, args::Real...; kw...
) where {Fun <: ModellingFunction}
    Fun(model |> ModelName, args...; kw...)
end

function (::Type{Fct})(model::ModelName; pars...) where {Fct <: ModellingFunctor}
    Fct(model, pars)
end

macro implement_modelling_functor(super_type, name)
    @eval begin
        struct $name <: $super_type
            model::ModelName
            pars::Pairs
        end

        function $name(model::Union{Symbol, <:AbstractString}, args...; pars...)
            $name(model |> ModelName, args...; pars...)
        end

        function (fct::$name)(args::Real...)
            $name(fct.model, args...; fct.pars...)
        end
    end
end