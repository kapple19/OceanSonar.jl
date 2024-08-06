export CelerityProfile

struct CelerityProfile{MediumType <: Medium, ProfileFunctionType <: Function} <: ModellingFunctor{3}
    profile::ProfileFunctionType

    function CelerityProfile{MediumType}(model::ModelName; pars...) where {MediumType <: Medium}
        celerity_profile = CelerityProfileFunctionType{MediumType}()
        profile(x::Real, y::Real, z::Real) = celerity_profile(model, x, y, z; pars...)
        new{MediumType, profile |> typeof}(profile)
    end
end

function (cel::CelerityProfile{<:Medium, <:Function})(x::Real, y::Real, z::Real)
    cel.profile(x, y, z)
end