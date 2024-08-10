# Sonar Equations Implementation Prototyping

```julia
using ModelingToolkit
```

```julia
@variables begin
    SL # [dB // μPa² m²]
    PL # [dB // m²]
    NL # total noise power level in the processing badn [dB // μPa²]
    NLf # noise spectrum level [dB // μPa² / Hz] (aka noise level in a 1-Hz band)
    AG # [dB]
    DT # [dB]
end
```

```julia
-NL + 10log10(Tp * B) == -NLf + 10log10(Tp)
-NL + 10log10(Tp) + 10log10(B) == -NLf + 10log10(Tp)
NL - 10log10(B) == NLf
```

```julia
abstract type GenericScenario end

abstract type ReverberationLimitedScenario <: GenericScenario end
abstract type NoiseLimitedScenario <: GenericScenario end
```

```julia
struct NumOfTx{N} end
NumOfTx(N::UInt8) = NumOfTx{N}()

struct NumOfRx{N} end
NumOfRx(N::UInt8) = NumOfRx{N}()
```

```julia
abstract type SonarType end

abstract type Passive <: SonarType end
abstract type Active{
    NumTx <: NumOfTx,
    NumRx <: NumOfRx,
    IS <: GenericScenario
} <: SonarType end

abstract type Broadband <: Passive end
abstract type Narrowband <: Passive end
abstract type Intercept <: Passive end
```

## Passive Sonar

```julia
let
    SNRᵃ = SL - PL - NL + AG
    SNRᵈ = SNRᵃ
    SE = SNRᵈ - DTᵈ
end
```

```julia
signal_to_noise_ratio(::Type{<:Passive}, SL, PL, NL, AG) = SL - PL - NL + AG
```

### Broadband

TODO.

```julia
let
    SNRᵃ = SL - PL - NL + AG
    SNRᵈ = SNRᵃ
    SE = SNRᵈ - DTᵈ
end
```

### Narrowband

TODO.

```julia
let
    SNRᵃ = SL - PL - NL + AG
    SNRᵈ = SNRᵃ
    SE = SNRᵈ - DTᵈ
end
```

## Active Sonar

### Monostatic Geometry

```julia
let
    RL = SL - 2PL + TSr
    SNRᵃ = SL - 2PL + TS - (NL ⊕ RL) + AG
    SNRᵈ = SNRᵃ + 10log10(Tₚ * B)
    SE = SNRᵈ - DTᵈ
end
```

```julia
function signal_to_noise_ratio(::Type{ActiveType},
    SL, PL, TS, NL, RL, AG, Tp, B
) where {
    ActiveType <: Active{
        <: NumOfTx{1},
        <: NumOfTx{1},
        <: GenericScenario
    }
}
    SL - 2PL + TS - (NL ⊕ RL) + AG + 10log10(Tp * B)
end
```

#### Noise-Limited Scenario

```julia
let
    NL ⊕ RL ≈ NL

    SNRᵃ = SL - 2PL + TS - (NL ⊕ RL) + AG
         ≈ SL - 2PL + TS - NL + AG

    SNRᵈ = SNRᵃ + 10log10(Tₚ * B)
         ≈ SL - 2PL + TS - NL + AG + 10log10(Tₚ * B)
         = SL - 2PL + TS - NLf + AG + 10log10(Tp)

    SE = SNRᵈ - DTᵈ
end
```

Pith: Increasing `SL` or `Tp` directly improves `SNRᵈ` irrespective of `B`.

```julia
function signal_to_noise_ratio(::Type{ActiveType},
    SL, PL, TS, NLf, AG, Tp
) where {
    ActiveType <: Active{
        <: NumOfTx{1},
        <: NumOfTx{1},
        <: NoiseLimitedScenario
    }
}
    SL - 2PL + TS - NLf + AG + 10log10(Tp)
end
```

#### Reverberation-Limited Scenario

```julia
let
    RL = SL - 2PL + TSr

    TSr = Sb + 10log10(2π * r * (cw * Tp / 2))

    NL ⊕ RL ≈ RL

    SNRᵃ = SL - 2PL + TS - (NL ⊕ RL) + AG
         ≈ SL - 2PL + TS - RL + AG
         = SL - 2PL + TS - (SL - 2PL + TSr) + AG
         = SL - 2PL + TS - SL + 2PL - TSr + AG
         = TS - TSr + AG
         = TS - (Sb + 10log10(2π * r * (cw * Tp / 2))) + AG

    SNRᵈ = SNRᵃ + 10log10(Tₚ * B)
         ≈ TS - (Sb + 10log10(2π * r * (cw * Tp / 2))) + AG + 10log10(Tₚ * B)
         = TS - (Sb + 10log10(2π * r * (cw / 2))) + AG + 10log10(B)

    SE = SNRᵈ - DTᵈ
end
```

Pith:

* Increasing `SL` or `Tp` does not improve `SNRᵃ`.
* Increasing `B` improves `SNRᵈ` irrespective of `Tp`.
* CW have inversely proportional `B * Tp = 1`.
* FM transmit waveform preferred over CW.

```julia
function signal_to_noise_ratio(::Type{ActiveType},
    TS, Sb, r, cw, AG, B
) where {
    ActiveType <: Active{
        <: NumOfTx{1},
        <: NumOfTx{1},
        <: ReverberationLimited
    }
}
    TS - (Sb + 10log10(2π * r * (cw / 2))) + AG + 10log10(B)
end
```
