export Transducers

@kwdef mutable struct Transducer{DirectivityFunctionType <: Function} <: ModelContainer
    position::Rectangular{RHanded, Float64, Float64, Float64}
    orientation::Spherical{RHanded, Nothing, Float64, Float64} = Spherical{RHanded}(θ = 0.0, φ = 0.0)
    directivity::DirectivityFunctionType = (θ::Real, φ::Real) -> 1.0
end

## models
Transducer(::Model{:Omnidirectional};
    x::Real = 0.0, y::Real = 0.0, z::Real = 0.0
) = Transducer(
    position = Rectangular{RHanded}(x, y, z),
)
