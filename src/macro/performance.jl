struct Ownship
    z
end

struct Target
    SL
    NL
end

struct Processing
    f
    B
    t
end

struct Environment
    NL
end

struct Reverberation
    RL
end

struct Performance
    SNR
    DT
    SE
    POD

    function Performance(
        sonar_type::Type{<:SonarType},
        scen::Scenario,
        own::Ownship,
        proc::Processing,
        env::Environment,
        tgt::Target,
        r::AbstractFloat,
        z::AbstractFloat
    )

        SL = if sonar_type <: Exposure
            tgt.NL
        elseif any(sonar_type .<: (Intercept, Active))
            tgt.SL
        end

        PL = propagation_loss(scen)

        NL = own.NL ⊕ env.NL

        RL = if sonar_type <: Passive
            -Inf
        elseif sonar_type <: Active
            reverberation_level(sonar_type, scen)
        end

        BIL = NL ⊕ RL

        SNR = if sonar_type <: Passive
            signal_to_noise_ratio(sonar_type, SL, prop.PL, NL, own.DI)
        elseif sonar_type <: Monostatic
            signal_to_noise_ratio(sonar_type, SL, prop.PL, NL, rvb.RL, own.DI)
        elseif sonar_type <: Bistatic
            prop_b = Propagation(prop.model, prop.scen, prop.config)
            signal_to_noise_ratio(sonar_type, SL, prop.PL, prob_b)
        end

        new(SL, BIL, SNR, DT, SE, POD)
    end
end

function performance(sonar_type::Type{<:Exposure},

    )

end

function performance(sonar_type::Type{<:Intercept},

    )

end

function performance(sonar_type::Type{<:Monostatic},
        slc::Slice,
        txr::Entity,
        rxr::Entity,
        tgt::Entity,

    )

end

function performance(sonar_type::Type{<:Bistatic},
        slc::Slice,
        txr::Entity,
        rxr::Entity,
        tgt::Entity,
        env::Environment,
        proc::Processing,
        ranges::AbstractVector{<:AbstractFloat},
        depths::AbstractVector{<:AbstractFloat}
    )
    scen_txr = Scenario(slc = slc, x = txr.x, z = txr.z, f = proc.f)
    scen_rxr = Scenario(slc = slc, x = rxr.x, z = rxr.z, f = proc.f)

    prop_txr = Propagation(scen_txr, ranges, depths)
    prop_rxr = Propagation(scen_rxr, ranges, depths)

    SL = txr.SL
    PLa = prop_txr.PL
    PLb = prop_rxr.PL
    TS = tgt.TS
    NL = rxr.NL ⊕ env.NL
    RL = reverberation_level(sonar_type, prop_txr, prop_rxr)
    SNR = signal_to_noise_ratio(sonar_type, SL, PLa, PLb, TS, NL, RL, DI)
    DT = detection_threshold(sonar_type, d, proc.B, proc.t)
    SE = SNR - DT
    tPd = transition_detection_probability(sonar_type, SE, Pf)
end