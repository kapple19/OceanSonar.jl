# Ocean Sound Speed Profiles

```@docs
sound_speed_profile
```

Many ocean sound speed profile models are available.

```@example
using OceanSonar
listmodels(sound_speed_profile)
```

Some notable models are described below.

## Homogeneous (Constant)

A constant sound speed model
with a configurable value,
defaulted to a typical ocean sound speed of 1500 m/s.

```@docs
sound_speed_profile(::Model{:Homogeneous}; c::Real = 1500.0)
```

## Munk

An idealistic but canonically-shaped sound speed profile.

```@docs
sound_speed_profile(::Model{:Munk}, z::Real; ϵ::Real = 7.37e-3)
```

```@example
using OceanSonar, CairoMakie
visual("Sound Speed 2D", 0, 5e3, Fix1(sound_speed_profile, "Munk"))
```
