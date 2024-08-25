# Beam-Grid Interpolation

```@example
using OceanSonar
using CairoMakie

for model in list_models(Scenario)
    scen = Scenario(model)
    prop = Propagation(:trace |> Val, scen)
    fig = propagationplot(prop,
        axis = (
            yreversed = true,
            title = val2model(scen.model)
        )
    )
    save("prop_" * val2snake(scen.model) * ".svg", fig)
end
```

![Propagation loss of parabolic bathymetry scenario](prop_parabolic_bathymetry.svg)

![Propagation loss of index-squared profile scenario](prop_index_squared_profile.svg)

![Propagation loss of Munk profile scenario](prop_munk_profile.svg)
