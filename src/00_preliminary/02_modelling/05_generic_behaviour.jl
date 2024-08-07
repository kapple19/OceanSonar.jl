function (FunctorType::Type{<:ModellingFunctor})(model::ModelName{M}; pars...) where {M}
    FunctorType(FunctorType |> EnvironmentComponent, model; pars...)
end

function (functor::ModellingFunctor)(args...; pars...)
    functor(functor |> EnvironmentComponent, args...; pars...)
end

function (FunctorType::Type{<:ModellingFunctor})(
    EC::EnvironmentComponent,
    model::ModelName{M},
    x₀::Real = 0.0,
    y₀::Real = 0.0,
    θ::Real = 0.0;
    pars...
) where {M}
    modelling_function = ModellingFunction(FunctorType)
    profile(args::Real...) = modelling_function(model, orienter(EC, args...; x₀ = x₀, y₀ = y₀, θ = θ)...; pars...)
    FunctorType{profile |> typeof}(profile)
end

function (functor::ModellingFunctor)(::EnvironmentComponent, args::Real...; pars...)
    functor.profile(args...)
end