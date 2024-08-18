
abstract type Handedness end
struct NotHanded <: Handedness end
abstract type HasHanded end
struct RHand <: HasHanded end
struct LHand <: HasHanded end

abstract type CoordinateType end

@kwdef struct Rectangular3D{H <: HasHanded} <: CoordinateType
    x::Float64 = 0.0
    y::Float64 = 0.0
    z::Float64 = 0.0
end

struct Cylindrical3D{H <: HasHanded} <: CoordinateType
    r::Float64 = 0.0
    θ::Float64 = 0.0
    z::Float64 = 0.0
end

struct Spherical3D{H <: HasHanded} <: CoordinateType
    ρ::Float64 = 0.0
    θ::Float64 = 0.0
    φ::Float64 = 0.0
end

struct HorizontalPolar2D{H <: HasHanded} <: CoordinateType
    r::Float64 = 0.0
    θ::Float64 = 0.0
end

struct VerticalPolar2D{H <: HasHanded} <: CoordinateType
    r::Float64 = 0.0
    φ::Float64 = 0.0
end

struct Spherical2D{H <: HasHanded} <: CoordinateType
    θ::Float64 = 0.0
    φ::Float64 = 0.0
end

struct Vertical{H <: HasHanded} <: CoordinateType
    z = 0.0
end

struct Horizontal{H <: NotHanded} <: CoordinateType
    r = 0.0
end

CoordinateType(::Function) = Rectangular3D{LHand}()
