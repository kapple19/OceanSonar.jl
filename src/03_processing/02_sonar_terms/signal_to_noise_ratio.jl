"""
```
signal_to_noise_ratio(::Type{<:Passive}, SL::Real, PL::Real, NL::Real, DI::Real)::Float64
```

Computes the Signal-to-Noise Ratio (SNR) [dB] as a function of (Abraham, 2019, Section 2.3.4):

* `SL` Source Level [dB // μPa² m² @ 1 m]
* `PL` Propagation Loss [dB // m²]
* `NL` Noise Level [dB // μPa²]
* `AG` Array Gain [dB]

Implementation of Equation 2.48 of Abraham (2019).
"""
function signal_to_noise_ratio(::Type{<:Passive}, SL::Real, PL::Real, NL::Real, AG::Real)::Float64
    SL - PL - NL + AG
end

function signal_to_noise_ratio(::Type{<:Monostatic}, SL::Real, PL::Real, TS::Real, RL::Real, NL::Real)::Float64
    SL - 2PL + TS - (NL ⊕ RL)
end
