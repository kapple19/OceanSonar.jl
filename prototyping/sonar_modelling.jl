## Symbols
(
    c = ("Sound Speed", )
)

## Modelling
struct Model{M} end
Model(M::Symbol) = Model{M}()

abstract type ModellingType <: Function end

(mt::ModellingType)(M::Symbol, args...; kw...) = mt(M |> Model, args...; kw...)

abstract type ProfileFunctor <: ModellingType end

(PF where {PF <: ProfileFunctor})(M::Symbol, args...; kw...) = PF{M |> Model}(args...; kw...)

## Traits
abstract type Handedness end
struct NotHanded <: Handedness end
abstract type HasHanded end
struct RHand <: HasHanded end
struct LHand <: HasHanded end

abstract type CoordinateType end

### 3D
struct Rectangular3D{H <: HasHanded} <: CoordinateType end

struct Cylindrical3D{H <: HasHanded} <: CoordinateType end

struct Spherical3D{H <: HasHanded} <: CoordinateType end

### 2D
struct HorizontalPolar2D{H <: HasHanded} <: CoordinateType end

struct VerticalPolar2D{H <: HasHanded} <: CoordinateType end

struct Spherical2D{H <: HasHanded} <: CoordinateType end

### 1D
struct Vertical{H <: HasHanded} <: CoordinateType end

struct Horizontal{H <: NotHanded} <: CoordinateType end

### 0D
struct Constant{H <: NotHanded} <: CoordinateType end

CoordinateType(::Function) = Rectangular3D{LHand}()

verticalsignchange(OldHand::H, NewHand::H) where {H <: HasHanded} = 1
verticalsignchange(OldHand::OH, NewHand::NH) where {OH <: HasHanded, NH <: HasHanded} = -1

function convertcoordinates(::VerticalPolar2D{OldHand}, ::Vertical{NewHand}, r::Real, z::Real) where {OldHand <: HasHanded, NewHand <: HasHanded}
    return (
        verticalsignchange(OldHand, NewHands) * z,
    )
end

## Profiles
abstract type ProfileFunction <: ModellingType end

struct SoundSpeedProfileFunction{M} <: ProfileFunction end

const sound_speed_profile{M <: Model} = SoundSpeedProfileFunction{M}()

function sound_speed{Model{:Munk}}(::Vertical{LHand}, z::Real; ϵ::Real = 7.37e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

##
struct SoundSpeed{M} <: ProfileFunctor
    model::Model{M}
    profile::Function

    function SoundSpeed(model::Model{M}; pars...) where {M}
        profile
        new{M}(model, profile)
    end
end

CoordinateType(::SoundSpeed{:Munk}) = Vertical{LHand}()

function (c::SoundSpeed{M} where {M})(input_coordinate_type::CoordinateType, coords...; pars...)
    c.profile(
        CoordinateType(c),
        convertcoordinates(
            input_coordinate_type,
            CoordinateType(c),
            coords...
        )...;
        pars...
    )
end

function sound_speed(::Model{:Munk}, ::Vertical{LHand}, z::Real; ϵ::Real = 7.37e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

struct ReflectionCoefficient{M} <: Function
    model::Model{M}
end

## Containers
mutable struct Medium
    c::SoundSpeed
end

mutable struct Interface
    z::Depth
    R::ReflectionCoefficient
end

mutable struct Environment
    surface::Interface
    bottom::Interface

    atmosphere::Medium
    ocean::Medium
    seabed::Medium
end

mutable struct Scenario2D

end

mutable struct Scenario3D

end

## Computations
abstract type Config end

struct BeamConfig <: Config

end

struct Beam
    path
    pressure

    Beam(::Model{:Ray})
    Beam(::Model{:Hat})
    Beam(::Model{:Gaussian})
end

struct Trace2D <: AbstractVector
    beams::Vector{<:Beam}

    Trace2D(::Model{:})
end

struct Trace3D <: AbstractArray
    beams::Vector{<:Beam}

    Trace3D(::Model{:})
end

struct Propagation2D <: AbstractMatrix
    positions
    pressure

    Propagation2D(::Model{:Trace2D}) = new()
    Propagation2D(::Model{:Parabolic}) = new()
end

struct Propagation3D
    r
    z
    θ
    p

    Propagation3D(::Model{:Trace2D}) = new()
    Propagation3D(::Model{:Trace3D}) = new()
end

struct Performance2D
    r
    z

    SL
    PL
    TS
    NL
    AG
    RL
    SNR
    DT
    SE
    POD

    Performance2D() = new()
end

struct Performance3D
    r
    z
    θ

    SL
    PL
    TS
    NL
    AG
    RL
    SNR
    DT
    SE
    POD

    Performance3D() = new()
end
