# Oceanic Celerity

```@docs
ocean_celerities
```

```@example
using OceanSonar
ocean_celerities
```

## Arctic

```@docs
OceanSonar.Models.OceanCelerities.arctic
```

```@example
using OceanSonar
using Plots

c = Celerity("arctic")
plot(c)
```

## Mediterranean

```@docs
OceanSonar.Models.OceanCelerities.mediterranean
```

```@example
using OceanSonar
using Plots

c = Celerity("mediterranean")
plot(c)
```

## Munk Profile

```@docs
OceanSonar.Models.OceanCelerities.munk
```

```@example
using OceanSonar
using Plots

c = Celerity("munk")
plot(c)
```

## North Atlantic

```@docs
OceanSonar.Models.OceanCelerities.north_atlantic
```

```@example
using OceanSonar
using Plots

c = Celerity("north_atlantic")
plot(c)
```

## Squared Index

```@docs
OceanSonar.Models.OceanCelerities.squared_index
```

```@example
using OceanSonar
using Plots

c = Celerity("squared_index")
plot(c)
```
