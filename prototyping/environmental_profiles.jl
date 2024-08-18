## Coordinate Handedness
abstract type Handedness end

struct UnHanded <: Handedness end

abstract type IsHanded <: Handedness end

struct RHand <: IsHanded end
struct LHand <: IsHanded end

## Coordinate System
abstract type CoordinateSystem end

struct Rectangular3D{H <: IsHanded} <: CoordinateSystem end
struct Cylindrical3D{H <: IsHanded} <: CoordinateSystem end
struct Spherical3D{H <: IsHanded} <: CoordinateSystem end

struct HorizontalPolar2D{H <: IsHanded} <: CoordinateSystem end
struct VerticalPolar2D{H <: IsHanded} <: CoordinateSystem end
struct Spherical2D{H <: IsHanded} <: CoordinateSystem end

struct Vertical{H <: IsHanded} <: CoordinateSystem end
struct Horizontal{H <: UnHanded} <: CoordinateSystem end

struct Constant{H <: UnHanded} <: CoordinateSystem end

## Coordinate Transformations


## Modelling Abstractions
struct Model{M} end
Model(M::Symbol) = Model{M}()

abstract type OceanSonarModel <: Function end

(OSM where {OSM <: OceanSonarModel})(M::Symbol, args...; kw...) = OSM(M |> Model, args...; kw...)

abstract type ProfileFunction <: OceanSonarModel end

abstract type ProfileFunctor <: OceanSonarModel end

function (profile_functor::ProfileFunctor)(M |> Model, centre::Real...; pars::Real...)
    profile_functor
end

## Model Definition
struct SoundSpeedFunctionType <: ProfileFunction end

const sound_speed = SoundSpeedFunctionType()

sound_speed(::Model{:Homogeneous}; c::Real) = c

CoordinateSystem(::SoundSpeedFunctionType, ::Model{:Homogeneous}) = Constant{UnHanded}()

function sound_speed(::Model{:Munk}, z::Real; ϵ::Real = 7.37e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

CoordinateSystem(::SoundSpeedFunctionType, ::Model{:Munk}) = Vertical{LHand}()

## Model Type
struct SoundSpeed{M, ProfileFunctionType} <: ProfileFunctor
    model::Model{M}
    profile::ProfileFunctionType
    
    function SoundSpeed(model::Model{M}, centre) where {M}
        profile()
    end
end

function (cel::SoundSpeed)(::Type{<:CoordinateSystem}, args...)

end

## Model Instantiation
sound_speed = SoundSpeed(:Munk, centre)

## Model Usage

sound_speed()
