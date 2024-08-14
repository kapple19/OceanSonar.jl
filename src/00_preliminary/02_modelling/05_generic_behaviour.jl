function (modelling_instance::ModellingType)(model::M, args...; kw...) where {M <: Union{Symbol, <:AbstractString}}
    modelling_instance(ModelName(model), args...; kw...)
end

function (ModellingSubtype::Type{<:ModellingType})(model::M, args...; kw...) where {M <: Union{Symbol, <:AbstractString}}
    ModellingSubtype(ModelName(model), args...; kw...)
end

function (FunctorType::Type{<:ModellingFunctor})(model::ModelName{M}; pars...) where {M}
    FunctorType(FunctorType |> SpatialDimensionSize, model; pars...)
end

function (functor::ModellingFunctor)(args...; pars...)
    functor(functor |> SpatialDimensionSize, args...; pars...)
end

function (FunctorType::Type{<:ModellingFunctor})(
    SDS::SpatialDimensionSize,
    model::ModelName{M},
    x₀::Real = 0.0,
    y₀::Real = 0.0,
    θ::Real = 0.0;
    pars...
) where {M}
    modelling_function = ModellingFunction(FunctorType)
    profile(args::Real...) = modelling_function(model, orient(SDS, args...; x₀ = x₀, y₀ = y₀, θ = θ)...; pars...)
    FunctorType{profile |> typeof}(profile)
end

function (functor::ModellingFunctor)(::SpatialDimensionSize, args::Real...; pars...)
    functor.profile(args...)
end

# function (container::ModellingContainer)(; kw...)
#     (
#         haskey(kw, field) ? kw[field] : @initialise_function()
#         for field in fieldnames(container)
#     ) |> splat(container)
# end
