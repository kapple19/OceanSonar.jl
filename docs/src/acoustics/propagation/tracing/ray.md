# Ray Tracing

```@example
using OceanSonar
using CairoMakie

for model in list_models(Scenario)
    scen = Scenario(model)
    angles = if scen.z == scen.env.ati(0)
        default_angles(scen, N = 21)
    else
        default_angles(scen, θ_max = critical_angle(scen), N = 21)
    end
    prop = Propagation(:trace |> Val, scen,
        angles = angles
    )
    fig = rayplot(prop,
        axis = (
            yreversed = true,
            title = val2model(scen.model)
        )
    )
    save("rays_" * val2snake(scen.model) * ".svg", fig)
end
```

![Ray trace of parabolic bathymetry scenario](rays_parabolic_bathymetry.svg)

![Ray trace of index-squared profile scenario](rays_index_squared_profile.svg)

![Ray trace of Munk profile scenario](rays_munk_profile.svg)
