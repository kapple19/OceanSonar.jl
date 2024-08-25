# Ray Tracing

```@docs
Ray
```

## Munk Profile

```@example
using OceanSonar
using Plots

scn = Scenario("munk_profile")
trc = Trace(scn)
plot(trc)
```

## Parabolic Bathymetry

```@example
using OceanSonar
using Plots

scn = Scenario("parabolic_bathymetry")
trc = Trace(scn)
plot(trc)
```
