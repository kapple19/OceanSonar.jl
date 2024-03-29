function signal_to_noise_ratio(::Type{<:Passive},
    SL::Real, PL::Real, NL::Real, DI::Real
)
    SL - PL - NL + DI
end

function signal_to_noise_ratio(::Type{<:Monostatic},
    SL::Real, PL::Real, NL::Real, RL::Real, DI::Real
)
    SL - 2PL - (NL ⊕ RL) + DI
end

function signal_to_noise_ratio(::Type{<:Bistatic},
    SL::Real, PLa::Real, PLb::Real, NL::Real, RL::Real, DI::Real
)
    SL - PLa - PLb - (NL ⊕ RL) + DI
end