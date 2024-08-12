orienter(::SpatialDimensionSize{2}, r::Real; x₀::Real, y₀::Real, θ::Real) = (x₀, y₀) .+ r .* cossin(θ)
orienter(SDS::SpatialDimensionSize{2}, x::Real, y::Real; x₀::Real, y₀::Real, θ::Real) = orienter(SDS, hypot(x, y); x₀ = x₀, y₀ = y₀, θ = θ)
orienter(::SpatialDimensionSize{3}, z::Real; x₀::Real, y₀::Real, θ::Real) = (x₀, y₀, z)
orienter(SDS::SpatialDimensionSize{3}, r::Real, z::Real; x₀::Real, y₀::Real, θ::Real) = orienter(SDS, z; x₀ = x₀, y₀ = y₀, θ = θ) .+ ((r .* cossin(θ))..., 0.0)
orienter(SDS::SpatialDimensionSize{3}, x::Real, y::Real, z::Real; x₀::Real, y₀::Real, θ::Real) = orienter(SDS, hypot(x, y), z; x₀ = x₀, y₀ = y₀, θ = θ)

# TODO: Let SpatialDimensionSize{3} call SpatialDimensionSize{2} where appropriate
