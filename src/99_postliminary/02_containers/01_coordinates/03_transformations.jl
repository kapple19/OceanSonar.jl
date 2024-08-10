
flip(::Type{UpwardDepth}) = DownwardDepth
flip(::Type{DownwardDepth}) = UpwardDepth

# flip!(pos::AbstractCoordinateSystem{<:PositiveDepthDirection})

function flip(pos::AbstractCoordinateSystem{<:PositiveDepthDirection})
    CoordinateSystem{flip(DepthDir)}(
        (
            axis => getproperty(pos, p) * (
                axis in (:z, :φ) ? -1 : 1
            )
            for axis in propertynames(pos)
        )
    )
end

function translate!(pos::AbstractCoordinateSystem; dx::Real = 0, dy::Real = 0, dz::Real = 0)
    pos.x += dx
    pos.y += dy
    pos.z += dz
end

function rotate!(pos::Union{<:SphericalCoordinate, <:CylindricalCoordinate}; dθ, dφ)
    pos.θ += dθ
    pos.φ += dφ
end
