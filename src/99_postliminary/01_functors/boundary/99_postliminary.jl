export BoundaryProfile

struct BoundaryProfile{InterfaceType <: OceanInterface, ProfileFunctionType <: Function} <: ModellingFunctor{2}
    profile::ProfileFunctionType

    function BoundaryProfile{InterfaceType}(model::ModelName; pars...) where {InterfaceType <: OceanInterface}
        boundary_profile = BoundaryProfileFunctionType{InterfaceType}()
        profile(x::Real, y::Real) = boundary_profile(model, x, y; pars...)
        new{InterfaceType, profile |> typeof}(profile)
    end
end

function (bnd::BoundaryProfile{<:OceanInterface, <:Function})(x::Real, y::Real)
    bnd.profile(x, y)
end
