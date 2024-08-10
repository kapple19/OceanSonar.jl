RectangularCoordinate(pos::CylindricalCoordinate{DepthDir}) where {
    DepthDir <: PositiveDepthDirection
} = RectangularCoordinate{DepthDir}(
    x = pos.r * cosd(pos.θ),
    y = pos.r * sind(pos.θ),
    z = pos.z,
)

RectangularCoordinate(pos::SphericalCoordinate{DepthDir}) where {
    DepthDir <: PositiveDepthDirection
} = RectangularCoordinate{DepthDir}(
    x = pos.ρ * cosd(pos.θ) * cosd(pos.φ),
    y = pos.ρ * sind(pos.θ) * cosd(pos.φ),
    z = pos.ρ * sind(pos.φ),
)

CylindricalCoordinate(pos::RectangularCoordinate{DepthDir}) where {
    DepthDir <: PositiveDepthDirection
} = CylindricalCoordinate{DepthDir}(
    r = hypot(pos.x, pos.y),
    θ = atand(pos.y, pos.x),
    z = pos.z,
)

CylindricalCoordinate(pos::SphericalCoordinate{DepthDir}) where {
    DepthDir <: PositiveDepthDirection
} = CylindricalCoordinate{DepthDir}(
    r = pos.ρ * cosd(pos.φ),
    θ = pos.θ,
    z = pos.ρ * sind(pos.φ),
)

SphericalCoordinate(pos::RectangularCoordinate{DepthDir}) where {
    DepthDir <: PositiveDepthDirection
} = SphericalCoordinate{DepthDir}(
    ρ = hypot(pos.x, pos.y, pos.z),
    θ = atand(pos.y, pos.x),
    φ = asind(pos.z),
)

SphericalCoordinate(pos::CylindricalCoordinate{DepthDir}) where {
    DepthDir <: PositiveDepthDirection
} = SphericalCoordinate{DepthDir}(
    ρ = hypot(pos.r, pos.z),
    θ = pos.θ,
    φ = asind(pos.z),
)
