struct DensityProfileFunctionType{MediumSymbol} <: Function end

const ocean_density_profile = DensityProfileFunctionType{:Ocean}()

ocean_density_profile(::Val{:Homogeneous}, z::Real; ρ::Real = 1500.0) = ρ

const seabed_density_profile = DensityProfileFunctionType{:Seabed}()

seabed_density_profile(::Val{:Homogeneous}, z::Real; ρ::Real = 3000.0) = ρ

abstract type OceanographyProfile <: Function end

struct DensityProfile{MediumSymbol, ProfileFunctionType <: Function} <: OceanographyProfile
    profile::ProfileFunctionType

    function DensityProfile{MediumSymbol}(model::Val; pars...) where {MediumSymbol}
        profile(z::Real) = ocean_density_profile(model, z; pars...)
        return new{MediumSymbol, profile |> typeof}(profile)
    end
end

function (den::DensityProfile{MediumSymbol, ProfileFunctionType} where {MediumSymbol, ProfileFunctionType})(z::Real)
    den.profile(z)
end

ocn_den = DensityProfile{:Ocean}(Val(:Homogeneous); ρ = 1520.0)
sbd_den = DensityProfile{:Seabed}(Val(:Homogeneous); ρ = 3200.0)
