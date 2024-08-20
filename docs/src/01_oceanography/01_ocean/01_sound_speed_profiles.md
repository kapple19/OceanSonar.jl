# Ocean Sound Speed Profiles

```@docs
sound_speed_profile
```

## Munk Sound Speed Profile

```@docs
sound_speed_profile(::Model{:Munk}, z::Real; ϵ::Real = 7.37e-3)
```

```@example
using OceanSonar, CairoMakie
visual("Sound Speed 2D", 0, 5e3, Fix1(sound_speed_profile, "Munk"))
```
