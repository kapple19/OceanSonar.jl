struct Orienter{D}
    x₀::Float64
    y₀::Float64
    θ::Float64
end

(orienter::Orienter{2})(r::Real) = (orienter.x₀, orienter.y₀) .+ r .* ocnson_cossin(orienter.θ)

(orienter::Orienter{2})(x::Real, y::Real) = ocnson_hypot(x, y) |> orienter

(orienter::Orienter{3})(z::Real) = (orienter.x₀, orienter.y₀, z)

(orienter::Orienter{3})(r::Real, z::Real) = orienter(z) .+ (
    (r .* ocnson_cossin(orienter.θ))...,
    0
)

(orienter::Orienter{3})(x::Real, y::Real, z::Real) = orienter(ocnson_hypot(x, y), z)
