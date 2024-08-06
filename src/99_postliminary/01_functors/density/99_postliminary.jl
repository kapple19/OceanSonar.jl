export DensityProfile

struct DensityProfile{MediumType <: AcousticMedium, ProfileFunctionType <: Function} <: SpatialModellingFunctor{3}
    profile::ProfileFunctionType

    function DensityProfile{MediumType}(model::ModelName; pars...) where {MediumType <: AcousticMedium}
        density_profile = DensityProfileFunctionType{MediumType}()
        profile(x::Real, y::Real, z::Real) = density_profile(model, x, y, z; pars...)
        new{MediumType, profile |> typeof}(profile)
    end
end

function (den::DensityProfile{<:AcousticMedium, <:Function})(x::Real, y::Real, z::Real)
    den.profile(x, y, z)
end