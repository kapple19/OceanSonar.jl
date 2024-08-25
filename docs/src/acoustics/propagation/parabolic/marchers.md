# Marchers

To be renamed.

```@example
using OceanSonar
using CairoMakie

θ_deg = range(0, 90, 301)
θ = deg2rad.(θ_deg)
q = -sin.(θ).^2

helmholtz(q) = √(1 + q)
helmholtz_q = helmholtz.(q)

fig = Figure()
ax = Axis(fig[1, 1],
    limits = (0, 90, 0, 0.001)
)

for model = list_models(OceanSonar.RationalFunctionApproximation)
    rfa = OceanSonar.RationalFunctionApproximation(model)
    errs = helmholtz_q - rfa.(q) .|> abs
    lines!(ax, θ_deg, errs,
        label = string(model, " (", length(rfa.a), ")")
    )
end
model = :pade
rfa = OceanSonar.RationalFunctionApproximation(model, m = 5)
errs = helmholtz_q - rfa.(q) .|> abs
lines!(ax, θ_deg, errs,
    label = string(model, " (", length(rfa.a), ")")
)

Legend(fig[0, 1], ax,
    orientation = :horizontal
)

save("phase_errors.svg", fig)
```

Replication of Figure 6.1b of Jensen, et al (2011).

![phase_errors.svg](phase_errors.svg)
