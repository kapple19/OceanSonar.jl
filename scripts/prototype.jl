##
using AbstractTrees
import AbstractTrees: children

# Modelling Types
abstract type ModellingType <: Function end

abstract type ModellingFunction <: ModellingType end
abstract type ModellingFunctor <: ModellingType end
abstract type ModellingContainer <: ModellingType end
abstract type ModellingComputation <: ModellingType end

# Environment Types
abstract type EnvironmentComponent end

abstract type OceanInterface <: EnvironmentComponent end
abstract type AcousticMedium <: EnvironmentComponent end

struct NotOceanSonarEnvironmentComponent <: EnvironmentComponent end

struct Surface <: OceanInterface end
struct Bottom <: OceanInterface end

struct Atmosphere <: AcousticMedium end
struct Ocean <: AcousticMedium end
struct Seabed <: AcousticMedium end

EnvironmentComponent(::Type) = NotOceanSonarEnvironmentComponent()
EnvironmentComponent(FunctorType::Type{<:ModellingFunctor}) = EnvironmentComponent(FunctorType |> ModellingFunction)
EnvironmentComponent(modelling_instance::ModellingType) = EnvironmentComponent(modelling_instance |> typeof)

# Umm
function (FunctorType::Type{<:ModellingFunctor})(model::Val; pars...)
    FunctorType(FunctorType |> EnvironmentComponent, model; pars...)
end

function (functor::ModellingFunctor)(args...; pars...)
    functor(functor |> EnvironmentComponent, args...; pars...)
end

function (FunctorType::Type{<:ModellingFunctor})(::OceanInterface, model::Val; pars...)
    modelling_function = ModellingFunction(FunctorType)
    profile(x::Real, y::Real) = modelling_function(model, x, y; pars...)
    FunctorType{profile |> typeof}(profile)
end

function (functor::ModellingFunctor)(::OceanInterface, x::Real, y::Real; pars...)
    functor.profile(x, y)
end

function (FunctorType::Type{<:ModellingFunctor})(::AcousticMedium, model::Val; pars...)
    modelling_function = ModellingFunction(FunctorType)
    profile(x::Real, y::Real, z::Real) = modelling_function(model, x, y, z; pars...)
    FunctorType{profile |> typeof}(profile)
end

function (functor::ModellingFunctor)(::AcousticMedium, x::Real, y::Real, z::Real; pars...)
    functor.profile(x, y, z)
end

# General Modelling Function
struct OceanCelerityType <: ModellingFunction end
const ocean_celerity = OceanCelerityType()

function ocean_celerity(::Val{:Jensen}, T::Real, S::Real, z::Real)
    c = 1449.2 + 4.6T - 0.055T^2 + 0.00029T^3 + (1.34 - 0.01T) * (S - 35) + 0.016z
end

OceanCelerityType = typeof(ocean_celerity)

# 2D Profile Modelling Function
struct BathymetryProfileType <: ModellingFunction end
const bathymetry_profile = BathymetryProfileType()
EnvironmentComponent(::BathymetryProfileType) = Bottom()

function bathymetry_profile(::Val{:Parabolic}, x::Real, y::Real;
    b = 250e3, c = 250.0
)::Float64
    r = hypot(x, y)
    2e-3b * sqrt(1 + r/c)
end

struct AltimetryProfileType <: ModellingFunction end
const altimetry_profile = AltimetryProfileType()
EnvironmentComponent(::AltimetryProfileType) = Bottom()

altimetry_profile(::Val{:Flat}, x::Real, y::Real; z::Real = 0)::Float64 = z

# 2D Profile Modelling Functor
struct BathymetryProfile{ProfileFunctionType <: Function} <: ModellingFunctor
    profile::ProfileFunctionType
end

ModellingFunction(::Type{<:BathymetryProfile}) = bathymetry_profile

struct AltimetryProfile{ProfileFunctionType <: Function} <: ModellingFunctor
    profile::ProfileFunctionType
end

ModellingFunction(::Type{<:AltimetryProfile}) = altimetry_profile

# 3D Profile Modelling Function
struct OceanCelerityProfileType <: ModellingFunction end
const ocean_celerity_profile = OceanCelerityProfileType()
EnvironmentComponent(::OceanCelerityProfileType) = Ocean()

function ocean_celerity_profile(::Val{:Munk}, x::Real, y::Real, z::Real; ϵ = 7.47e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

struct SeabedCelerityProfileType <: ModellingFunction end
const seabed_celerity_profile = SeabedCelerityProfileType()
EnvironmentComponent(::SeabedCelerityProfileType) = Seabed()

seabed_celerity_profile(::Val{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 2000.0)::Real = c

struct OceanDensityProfileType <: ModellingFunction end
const ocean_density_profile = OceanDensityProfileType()
EnvironmentComponent(::OceanDensityProfileType) = Ocean()

ocean_density_profile(::Val{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 1029.0)::Real = ρ

struct SeabedDensityProfileType <: ModellingFunction end
const seabed_density_profile = SeabedDensityProfileType()
EnvironmentComponent(::SeabedDensityProfileType) = Seabed()

seabed_density_profile(::Val{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 3000.0)::Real = ρ

# 3D Profile Modelling Functor
struct OceanCelerityProfile{ProfileFunctionType <: Function} <: ModellingFunctor
    profile::ProfileFunctionType
end

ModellingFunction(::Type{<:OceanCelerityProfile}) = ocean_celerity_profile

struct SeabedCelerityProfile{ProfileFunctionType <: Function} <: ModellingFunctor
    profile::ProfileFunctionType
end

ModellingFunction(::Type{<:SeabedCelerityProfile}) = seabed_celerity_profile

struct OceanDensityProfile{ProfileFunctionType <: Function} <: ModellingFunctor
    profile::ProfileFunctionType
end

ModellingFunction(::Type{<:OceanDensityProfile}) = ocean_density_profile

struct SeabedDensityProfile{ProfileFunctionType <: Function} <: ModellingFunctor
    profile::ProfileFunctionType
end

ModellingFunction(::Type{<:SeabedDensityProfile}) = seabed_density_profile

# Tree Diagrams
children(::Type{T}) where {T <: ModellingType} = subtypes(T)
children(::Type{T}) where {T <: EnvironmentComponent} = subtypes(T)
