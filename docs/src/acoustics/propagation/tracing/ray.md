# Ray Tracing

```@example
using OceanSonar
using CairoMakie

for model in list_models(Scenario)
    scen = Scenario(model)
    prop = @time "$model" Propagation(:trace, scen,
        angles = critical_angles(scen, 21)
    )
    fig = rayplot(prop,
        axis = (
            yreversed = true,
            title = modeltitle(scen.model)
        )
    )
    save("rays_" * modelsnake(scen.model) * ".svg", fig)
end
```

![rays_parabolic_bathymetry.svg](rays_parabolic_bathymetry.svg)

![rays_index_squared_profile.svg](rays_index_squared_profile.svg)

![rays_munk_profile.svg](rays_munk_profile.svg)

![rays_lloyd_mirror.svg](rays_lloyd_mirror.svg)
