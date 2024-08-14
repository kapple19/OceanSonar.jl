## Generic Form
abstract type EmissionType end

struct NoiseOnly <: EmissionType end
struct Signaling <: EmissionType end

abstract type AbstractEntity end

struct AbsentEntity <: AbstractEntity end

mutable struct Entity{ET <: EmissionType} <: AbstractEntity
    SL::Float64
    NL::Float64
    pos::RectangularCoordinate{2}
end

function Entity{ETnew <: EmissionType}(ent::Entity{ETold}) where {ETold <: EmissionType}
    Entity{ETnew}(field => getpropert(ent, field) for field in fieldnames(Entity))
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

reverberation_level(env::Environment, prop::SonarPropagation, own::Entity{Signaling}, tgt::Entity{NoiseOnly}, fac::AbsentEntity = AbsentEntity()) = reverberation_level(env, prop, own)
reverberation_level(env::Environment, prop::SonarPropagation, own::Entity{NoiseOnly}, tgt::Entity,            fac::AbsentEntity = AbsentEntity()) = 0.0
reverberation_level(env::Environment, prop::SonarPropagation, own::Entity{NoiseOnly}, tgt::Entity{NoiseOnly}, fac::Entity{Signaling}            ) = reverberation(env, prop, own, fac)

@kwdef struct AcousticConfig
    beam_model::ModelName = ModelName("Gaussian")
end

@kwdef struct PropagationConfig
    acoustic_config::AcousticConfig = AcousticConfig("BeamTracing")
end

struct SonarPropagation
    to_ownship
    from_facilitator

    SonarPropagation(config::PropagationConfig, env::Environment, grid::Grid, own::Entity, fac::AbsentEntity = AbsentEntity())
    SonarPropagation(config::PropagationConfig, env::Environment, grid::Grid, own::Entity, fac::Entity{Signaling})
end

struct SonarPerformance
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
    
    function SonarPerformance(env::Environment, proc::Processing, grid::Grid, own::Entity, tgt::Entity, fac::AbstractEntity = AbsentEntity();
            prop_config::PropagationConfig = PropagationConfig()
        )
        SL = source_level(own, tgt, fac)
        prop = SonarPropagation(prop_config, env, grid, own, fac)
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

## Equation Form
abstract type Sonar end

abstract type Passive <: Sonar end
abstract type Active <: Sonar end

abstract type Narrowband <: Passive end
abstract type Broadband <: Passive end
abstract type Intercept <: Passive end

abstract type CombinedInterference <: Active end
abstract type ReverberationLimited <: Active end
abstract type AmbientNoiseLimited <: Active end

sonar_equation(::Sonar) = (SL, PLa, PLb, TS, NL, RL, AG, DT) -> SL - PLa + TS - PLb + ((NL - AG) ⊕ RL) - DT
sonar_equation(::Passive) = (SL, PL, NL, AG, DT) -> SL - PL - NL + AG - DT
sonar_equation(::Narrowband) = () -> NaN
sonar_equation(::Broadband) = () -> NaN
sonar_equation(::Intercept) = () -> NaN
sonar_equation(::CombinedInterference) = () -> NaN
sonar_equation(::ReverberationLimited) = () -> NaN
sonar_equation(::AmbientNoiseLimited) = () -> NaN
