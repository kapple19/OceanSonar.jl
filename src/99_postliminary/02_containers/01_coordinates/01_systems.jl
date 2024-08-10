export DownwardDepth
export UpwardDepth

export RectangularCoordinate
export CylindricalCoordinate
export SphericalCoordinate

abstract type PositiveDepthDirection end
struct DownwardDepth <: PositiveDepthDirection end
struct UpwardDepth <: PositiveDepthDirection end

abstract type AbstractCoordinateSystem{DepthDir <: PositiveDepthDirection} end

@kwdef mutable struct RectangularCoordinate{DepthDir} <: AbstractCoordinateSystem{DepthDir}
    x::Float32
    y::Float32
    z::Float32 = 0.0
end

@kwdef mutable struct CylindricalCoordinate{DepthDir} <: AbstractCoordinateSystem{DepthDir}
    r::Float32
    θ::Float32
    z::Float32 = 0.0
end

@kwdef mutable struct SphericalCoordinate{DepthDir} <: AbstractCoordinateSystem{DepthDir}
    ρ::Float32
    θ::Float32
    φ::Float32
end
