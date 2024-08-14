export DownwardDepth
export UpwardDepth

export RectangularCoordinate
export CylindricalCoordinate
export SphericalCoordinate

abstract type PositiveDepthDirection end
struct DownwardDepth <: PositiveDepthDirection end
struct UpwardDepth <: PositiveDepthDirection end

abstract type AbstractCoordinateSystem{DepthDir <: PositiveDepthDirection} end

RectangularCoordinateNaN(DepthDir::Type{<:PositiveDepthDirection}) = RectangularCoordinate{DepthDir}(x = NaN32, y = NaN32, z = NaN32)

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

# function show(io::IO, ::MIME"text/plain", pos::AbstractCoordinateSystem{DepthDir}) where {DepthDir <: PositiveDepthDirection}
    
# end