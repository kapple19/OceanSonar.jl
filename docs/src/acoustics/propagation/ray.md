# Acoustic Ray Tracing

```@example
using OceanSonar
using CairoMakie

scen = Scenario(:munk_profile |> Val, 0.0, 1e3)
prop = Propagation(:ray |> Val, scen, range(0, 100e3, 31), range(0, 2e3, 21), 1e3, atan(1e3 / 10e3) * range(-1, 1, 301))

fig_rays = Figure()
ax = Axis(fig_rays[1, 1])
lines!.(ax, prop.rays)
fig_rays

fig_loss, _, hm_loss = heatmap(prop, colormap = Reverse(:jet))
Colorbar(fig_loss[:, end+1], hm_loss,
    flipaxis = false # not working: true and false produce same result
)

ray = prop.rays[1]
s = ray.s_vec
n = 10.0range(-1, 1, 101)
PL = [-20log10(ray.p(s_, n_) |> abs) for s_ in s, n_ in n]
fig_beam, _, hm_beam = heatmap(s, n, PL, colormap = Reverse(:jet))
Colorbar(fig_beam[:, end+1], hm_beam,
    flipaxis = false # not working: true and false produce same result
)

fig_ray = lines(s, ray.z.(s))

save("ray_trace_eg.png", fig_rays) # hide
save("prop_loss_eg.png", fig_loss) # hide
save("beam_eg.png", fig_beam) # hide
save("ray_eg.png", fig_ray) # hide

nothing # hide
prop.PL
```

![Ray trace example](ray_trace_eg.png)

![Propagation loss example](prop_loss_eg.png)

![Beam example](beam_eg.png)

![Ray example](ray_eg.png)
