# Ray Tracing

```@example
using OceanSonar
using Plots

for model in list_models(Scenario)
    scen = Scenario(model)
    prop = @time "$model" Propagation(:trace, scen,
        angles = critical_angles(scen, N = 21)
    )
    fig = visual(Beam, prop)
    savefig(fig, "rays_" * modelsnake(scen.model) * ".svg")
end
```

![rays_parabolic_bathymetry.svg](rays_parabolic_bathymetry.svg)

![rays_index_squared_profile.svg](rays_index_squared_profile.svg)

![rays_munk_profile.svg](rays_munk_profile.svg)

![rays_lloyd_mirror.svg](rays_lloyd_mirror.svg)
