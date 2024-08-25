# Acoustic Tracing Interpolation to Grid

```@example
using OceanSonar
using Plots
using .Threads

@time "all" begin
    begin
        models = list_models(Scenario)
        for m in eachindex(models)
            model = models[m]
            scen = Scenario(model)
            prop = @time "$model" Propagation(:trace, scen,
                angles = critical_angles(scen)
            )
            fig = visual(prop)
            savefig(fig, "prop_" * modelsnake(scen.model) * ".svg")
        end
    end
end
```

![prop_parabolic_bathymetry.svg](prop_parabolic_bathymetry.svg)

![prop_index_squared_profile.svg](prop_index_squared_profile.svg)

![prop_munk_profile.svg](prop_munk_profile.svg)

![prop_lloyd_mirror.svg](prop_lloyd_mirror.svg)
