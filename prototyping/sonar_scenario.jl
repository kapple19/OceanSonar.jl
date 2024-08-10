abstract type VerticalDirection end
abstract type Downward <: VerticalDirection end
abstract type Upward <: VerticalDirection end

struct RectangularHorizontalCoordinate2D
    x::Float64
    y::Float64
end

struct RectangularVerticalCoordinate2D{VD <: VerticalDirection}
    r::Float64
    z::Float64
end

struct PolarHorizontalCoordinate2D
    r::Float64
    θ::Float64
end

struct SphericalCoordinate2D{VD <: VerticalDirection}
    θ::Float64
    φ::Float64
end

struct PolarVerticalCoordinate2D{VD <: VerticalDirection}
    r::Float64
    φ::Float64
end

struct RectangularCoordinate3D{VD <: VerticalDirection}
    x::Float64
    y::Float64
    z::Float64
end

struct CylindricalCoordinate3D{VD <: VerticalDirection}
    r::Float64
    θ::Float64
    z::Float64
end

struct SphericalCoordinate3D{VD <: VerticalDirection}
    r::Float64
    θ::Float64
    φ::Float64
end

function RectangularCoordinate(pos::CylindricalCoordinate3D{VD}) where {VD <: VerticalDirection}
    RectangularCoordinate3D{VD}(pos.r * cos(pos.θ), pos.r * sin(pos.θ), pos.z)
end

struct AcousticSensor{ResponseFunctionType <: Function}
    name::String
    response::ResponseFunctionType
end

struct AcousticArray{SourceLevelFunctionType <: Function}
    name::String
    acoustic_sensors::Vector{@NamedTuple{position::RectangularCoordinate3D{Upward}, sensor::AcousticSensor, weight::Float64}}
    source_level::SourceLevelFunctionType
end

struct Entity{
    NoiseLevelFunctionType <: Function,
    TargetStrengthFunctionType <: Function
}
    name::String
    noise_level::NoiseLevelFunctionType
    target_strength::TargetStrengthFunctionType
    arrays::Dict{String, @NamedTuple{position::CylindricalCoordinate3D{Upward}, orientation::SphericalCoordinate2D{Upward}}}
end

struct EntityPlacement{
    NoiseLevelFunctionType <: Function,
    TargetStrengthFunctionType <: Function
}
    entity::Entity{NoiseLevelFunctionType, TargetStrengthFunctionType}
    position::CylindricalCoordinate3D{Upward}
    orientation::SphericalCoordinate2D{Upward}
end

@kwdef mutable struct AcousticMedium{
    DensityFunctionType <: Function,
    WindFunctionType <: Function,
    SoundSpeedFunctionType <: Function,
    ShearSoundSpeedFunctionType <: Function,
    AttenuationFunctionType <: Function,
    ShearAttenuationFunctionType <: Function
}
    density::DensityFunctionType = @initialise_function
    wind_speed::WindFunctionType = @initialise_function
    sound_speed::SoundSpeedFunctionType = @initialise_function
    shear_sound_speed::ShearSoundSpeedFunctionType = @initialise_function
    attenuation::AttenuationFunctionType = @initialise_function
    shear_attenuation::ShearAttenuationFunctionType = @initialise_function
end

"""
TODO: Figure out how to implement an arbitrary number of layers whilst keeping type stability.
"""
struct Environment{
    AtmosphereHeightFunctionType <: Function,
    SedimentDepthFunctionType <: Function,
    BasementDepthFunctionType <: Function,
}
    atmosphere::@NamedTuple{height::AtmosphereHeightFunctionType, medium::AcousticMedium}
    ocean::AcousticMedium
    sediment::@NamedTuple{depth::SedimentDepthFunctionType, medium::AcousticMedium}
    basement::@NamedTuple{depth::BasementDepthFunctionType, medium::AcousticMedium}
end

abstract type WaveForm end

struct LFM <: WaveForm end
struct HFM <: WaveForm end

abstract type SignalProcessing end

struct NarrowbandProcessing <: SignalProcessing end
struct BroadbandProcessing <: SignalProcessing end
struct InterceptProcessing <: SignalProcessing end
struct ContinuousWaveProcessing <: SignalProcessing end
struct FrequencyModulatedProcessing{WF <: WaveForm} <: SignalProcessing end

struct Propagation3D
    function Propagation3D(
        environment::Environment,
        entity::EntityPlacement
    )
        
    end
end

"""
TODO:
* Incorporate beampatterns of transmitters, target reflection, and receivers.
"""
function propagation(environment, entities, transmitter_names, target_name, receiver_names, x_values, y_values, z_values)
    p = zeros(ComplexF64, ((x_values, y_values, z_values) .|> length)...)

    return @. -20log10(p |> abs)
end

struct SonarPerformance
    environment::Environment

    processing::SignalProcessing

    entities::Dict{String, EntityPlacement}
    target_name::String
    transmitter_names::String
    receiver_names::Vector{String}

    x::AbstractVector{Float64}
    y::AbstractVector{Float64}
    z::AbstractVector{Float64}

    PL::Array{3, Float64}

    function SonarPerformance(
        environment::Environment,
        processing::SignalProcessing,
        entities::Dict{String, EntityPlacement},
        x_values::AbstractVector{<:Real},
        y_values::AbstractVector{<:Real},
        z_values::AbstractVector{<:Real},
        receiver_names::AbstractVector{<:AbstractString},
        target_name::AbstractString,
        transmitter_names::AbstractString = String[]
    )
        @assert allunique(entity -> entity.name, entities)

        target = entities_dict[target_name].entity

        "Weighted-pressure ray trace from each transmitter and receiver."
        propagations = Dict(
            name => Beams(environment, entities[name])
            for name in [transmitter_names; receiver_names]
        )

        SL_PL_TS, NL, RL = propagation(environment, entities, transmitter_names, target_name, receiver_names, x_values, y_values, z_values)

        DI = directivity_index(environment, processing, entities, transmitter_names, target_name, receiver_names, x_values, y_values, z_values)

        DT = detection(environment, processing, entities, transmitter_names, target_name, receiver_names, x_values, y_values, z_values)

        SNR = @. SL_PL_TS - NL_RL_DI
        SE = @. SNR - DT

        new(
            environment,
            processing,
            entities,
            target_name,
            transmitter_names,
            receiver_names,
            x_values,
            y_values,
            z_values,
            SL_PL_TS,
            NL_RL_DI,
            DT,
            SNR,
            SE
        )
    end
end
