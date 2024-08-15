source_level(own::Entity{Signaling}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = own.SL
source_level(own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = tgt.NL
source_level(own::Entity{NoiseOnly}, tgt::Entity{Signaling}, fac::AbsentEntity = AbsentEntity()) = tgt.SL
source_level(own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::Entity{Signaling}            ) = fac.SL

target_strength(own::Entity{Signaling}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = tgt.TS
target_strength(own::Entity{NoiseOnly}, tgt::Entity,            fac::AbsentEntity = AbsentEntity()) = 0.0
target_strength(own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::Entity{Signaling}            ) = tgt.TS

@kwdef struct OceanGrid
    r::Vector{Float64}
    z::Vector{Float64}
    θ::Vector{Float64}
end

struct SonarPropagation <: ModellingComputation
    to_ownship::Fan
    from_facilitator::Union{Nothing, Fan}

    function SonarPropagation(env::Environment, grid::OceanGrid, own::Entity, fac::AbstractEntity)
        new(
            Fan(),
            fac::AbsentEntity ? nothing : Fan()
        )
    end
end

transmission_loss(prop::SonarPropagation, own::Entity{Signaling}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = 2 * prop.from_ownship
transmission_loss(prop::SonarPropagation, own::Entity{NoiseOnly}, tgt::Entity,            fac::AbsentEntity = AbsentEntity()) = prop.from_ownship
transmission_loss(prop::SonarPropagation, own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::Entity{Signaling}            ) = prop.from_ownship + prop.from_facilitator

reverberation_level(env::Environment, prop::SonarPropagation, own::Entity{Signaling}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = reverberation_level(env, prop, own)
reverberation_level(env::Environment, prop::SonarPropagation, own::Entity{NoiseOnly}, tgt::Entity,            fac::AbsentEntity = AbsentEntity()) = 0.0
reverberation_level(env::Environment, prop::SonarPropagation, own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::Entity{Signaling}            ) = reverberation_level(env, prop, own, fac)

abstract type Processing end

struct Narrowband <: Processing
    f::Float64
    Pf::Float64
    Pd::Float64

    "`δt` FFT binwidth."
    δt::Float64
end

detection_index(proc::Narrowband) = detection_index(:Narrowband, proc.Pf, proc.Pd)
detection_index(proc::Broadband) = detection_index(:Broadband, proc.Pf, proc.Pd)
detection_index(proc::Intercept) = detection_index(:Intercept, proc.Pf, proc.Pd)
detection_index(proc::ContinuousWave) = detection_index(:ContinuousWave, proc.Pf, proc.Pd)
detection_index(proc::FrequencyModulated) = detection_index(:FrequencyModulated, proc.Pf, proc.Pd)

processing_gain()

detection_threshold()

struct SonarPerformance <: ModellingComputation
    SL
    TL
    TS
    NL
    RL
    AG
    SNR
    DT
    SE
    POD

    function SonarPerformance(env::Environment, proc::Processing, grid::OceanGrid, own::Entity, tgt::Entity, fac::AbstractEntity = AbsentEntity())
        SL = source_level(own, tgt, fac)
        prop = SonarPropagation(env, grid, own, fac)
        TL = transmission_loss(prop, own, tgt, fac)
        TS = target_strength(own, tgt, fac)
        NL = env.NL ⊕ own.NL
        RL = reverberation_level(env, prop, own, tgt, fac)
        AG = array_gain(env, own)
        DT = detection_threshold(own, tgt, fac)

        SNR = SL - TL + TS - ((NL - AG) ⊕ RL)
        SE = SNR - DT
        
        POD = probability_of_detection(proc, own, tgt, fac, SE)

        new(SL, TL, TS, NL, RL, AG, SNR, DT, SE, POD)
    end
end
