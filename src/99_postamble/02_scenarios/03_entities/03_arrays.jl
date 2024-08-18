export SonarArray

@kwdef mutable struct SonarArray <: ModelContainer
    transducers::Vector{Transducer} = [Transducer(:Omnidirectional)]
    position::Cylindrical{RHanded, Float64, Float64, Float64} = Cylindrical{RHanded}(0.0, 0.0, 0.0)
end

function beampattern(arr::SonarArray, λ::Real, θ::Real, φ::Real, θ₀::Real, φ₀::Real)

end

function directivity_index(arr::SonarArray, λ::Real, θ₀::Real, φ₀::Real)
    
end

function array_gain(env::Environment, arr::SonarArray, λ::Real, θ₀::Real, φ₀::Real)

end

## Models
SonarArray(::Model{:Monopole}) = SonarArray()
