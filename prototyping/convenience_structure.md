# Convenience Structure

* Dispatchable structure.
* Function fields can be `OceanSonar.ModellingFunctor <: ... <: Function` or not.
* Design plotting recipes to enable conveniences on the flexibility of whether a user defined a field as an `OceanSonar.ModellingFunctor`.

```julia
abstract type Position3D end

@kwdef mutable struct RectangularPosition3D <: Position3D

end

@kwdef mutable struct 

@kwdef mutable struct Sensor

end

@kwdef mutable struct SensorArray{
    N,
    Position3DType <: AbstractPosition,
    BeamPatternFunctionType <: Function,
    DirectivityIndexFunctionType <: Function,
}
    sensors::NTuple{N, sensor::@NamedTuple{N, Sensor}, position::Position3DType}

    beam_pattern::BeamPatternFunctionType
    directivity_index::DirectivityIndexFunctionType
end
```
