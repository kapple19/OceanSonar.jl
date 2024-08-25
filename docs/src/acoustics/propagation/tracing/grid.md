# Beam-Grid Interpolation

```@example
using OceanSonar
using CairoMakie
using .Threads

@time "all" begin
    begin
        models = list_models(Scenario)
        @threads for m in eachindex(models)
            model = models[m]
            scen = Scenario(model)
            prop = @time "$model" Propagation(:trace, scen,
                angles = critical_angles(scen)
            )
            fig = propagationplot(prop,
                axis = (
                    yreversed = true,
                    title = modeltitle(scen.model)
                )
            )
            save("prop_" * modelsnake(scen.model) * ".svg", fig)
        end
    end
end
```

![prop_parabolic_bathymetry.svg](prop_parabolic_bathymetry.svg)

![prop_index_squared_profile.svg](prop_index_squared_profile.svg)

![prop_munk_profile.svg](prop_munk_profile.svg)

![prop_lloyd_mirror.svg](prop_lloyd_mirror.svg)
