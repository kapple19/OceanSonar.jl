export Entity
export AbsentEntity

abstract type AbstractEntity <: ModelContainer end

struct AbsentEntity{ET <: EmissionType} <: AbstractEntity end

@kwdef mutable struct Entity{ET <: EmissionType} <: AbstractEntity
    position::Union{Rectangular{LHanded, Float64, Float64, Float64}, NoCoordinates} = NoCoordinates()
    orientation::Spherical{RHanded, Nothing, Float64, Float64} = Spherical{RHanded}(θ = 0.0, φ = 0.0)
    array::SonarArray = SonarArray()
end

Entity(::Model{:GenericOwnship}) = Entity{NoiseOnly}(
    position = Rectangular{LHanded}(0.0, 0.0, 0.0),
    array = SonarArray(:Monopole)
)

Entity(::Model{:GenericTarget}) = Entity{Signaling}()
