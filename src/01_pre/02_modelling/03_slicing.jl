struct Slicer2D{D}
    x₀::Float64
    y₀::Float64
    θ::Float64

    Slicer2D{D}(x₀::Real = 0, y₀::Real = 0, θ::Real = 0) where D = new(x₀, y₀, θ)
end

(slicer::Slicer2D{1})(r::Real) = (slicer.x₀ + r*cos(slicer.θ), slicer.y₀ +r*sin(slicer.θ))
function (slicer::Slicer2D{2})(x::Real, y::Real)
    r = hypot(x, y)
    (slicer.x₀ + r*cos(slicer.θ), slicer.y₀ + r*sin(slicer.θ))
end

struct Slicer3D{D}
    x₀::Float64
    y₀::Float64
    θ::Float64

    Slicer3D{1}(x₀::Real = 0, y₀::Real = 0) = new(x₀, y₀)
    Slicer3D{2}(x₀::Real = 0, y₀::Real = 0, θ::Real = 0) = new(x₀, y₀, θ)
    Slicer3D{3}(x₀::Real = 0, y₀::Real = 0, θ::Real = 0) = new(x₀, y₀, θ)
end

(slicer::Slicer3D{1})() = (slicer.x₀, slicer.y₀)
(slicer::Slicer3D{2})(r::Real) = (slicer.x₀ + r*ocnson_cos(slicer.θ), slicer.y₀ +r*ocnson_sin(slicer.θ))
(slicer::Slicer3D{3})(x::Real, y::Real) = (slicer.x₀ + x*ocnson_cos(slicer.θ), slicer.y₀ + y*ocnson_sin(slicer.θ))