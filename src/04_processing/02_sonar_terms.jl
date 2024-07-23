export signal_to_noise_ratio

function signal_to_noise_ratio(::Type{<:Passive}, SL, PL, NL, AG)
    SNR = SL - PL - NL + AG
end

function signal_to_noise_ratio(::Type{<:Monostatic}, SL, PL, TS, NL, RL, AG)
    SNR = SL - 2PL + TS - (NL ⊕ RL) + AG
end

function signal_to_noise_ratio(::Type{<:Bistatic}, SL, PLa, PLb, TS, NL, RL, AG)
    SNR = SL - PLa - PLb + TS - (NL ⊕ RL) + AG
end

sonar_terms = (
    SL = signal_to_noise_ratio,
)
