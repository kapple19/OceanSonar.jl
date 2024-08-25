# Beam Tracing

```@docs
Beam
```

## Munk Profile

```@example
using OceanSonar
using Plots

scn = Scenario("munk_profile")
trc = Trace(scn, tracer = Tracer("gaussian_beam"))
plot(trc)
```

## Parabolic Bathymetry

```@example
using OceanSonar
using Plots

scn = Scenario("parabolic_bathymetry")
trc = Trace(scn, tracer = Tracer("gaussian_beam"))
plot(trc)
```
