abstract type EmissionType end

struct NoiseOnly <: EmissionType end
struct Signaling <: EmissionType end

abstract type AbstractEntity{ET <: EmissionType} end

struct AbsentEntity <: AbstractEntity end

struct Entity{ET <: EmissionType} <: AbstractEntity
    SL::Float64
    NL::Float64
    pos::RectangularCoordinate{2}
end

source_level(own::Entity{Signaling}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = own.SL
source_level(own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = tgt.NL
source_level(own::Entity{NoiseOnly}, tgt::Entity{Signaling}, fac::AbsentEntity = AbsentEntity()) = tgt.SL
source_level(own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::Entity{Signaling}            ) = fac.SL

transmission_loss(own::Entity{Signaling}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = 2 * prop.from_ownship
transmission_loss(own::Entity{NoiseOnly}, tgt::Entity,            fac::AbsentEntity = AbsentEntity()) = prop.from_ownship
transmission_loss(own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::Entity{Signaling}            ) = prop.from_ownship + prop.from_facilitator

target_strength(own::Entity{Signaling}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = tgt.TS
target_strength(own::Entity{NoiseOnly}, tgt::Entity,            fac::AbsentEntity = AbsentEntity()) = 0.0
target_strength(own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::Entity{Signaling}            ) = tgt.TS

reverberation_level(env::Environment, prop::Propagation, own::Entity{Signaling}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = reverberation_level(env, prop, own)
reverberation_level(env::Environment, prop::Propagation, own::Entity{NoiseOnly}, tgt::Entity,            fac::AbsentEntity = AbsentEntity()) = 0.0
reverberation_level(env::Environment, prop::Propagation, own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::Entity{Signaling}            ) = reverberation(env, prop, own, fac)

@kwdef struct AcousticConfig
    beam_model::ModelName = ModelName("Gaussian")
end

@kwdef struct PropagationConfig
    acoustic_config::AcousticConfig = AcousticConfig("BeamTracing")
end

struct Propagation
    to_ownship
    from_facilitator

    Propagation(config::PropagationConfig, env::Environment, grid::Grid, own::Entity, fac::AbsentEntity = AbsentEntity())
    Propagation(config::PropagationConfig, env::Environment, grid::Grid, own::Entity, fac::Entity{Signaling})
end

struct SonarEquation
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
    
    function SonarEquation(env::Environment, proc::Processing, grid::Grid, own::Entity, tgt::Entity, fac::AbstractEntity = AbsentEntity();
            prop_config::PropagationConfig = PropagationConfig()
        )
        SL = source_level(own, tgt, fac)
        prop = Propagation(prop_config, env, grid, own, fac)
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
