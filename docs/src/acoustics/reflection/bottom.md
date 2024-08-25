# Bottom Reflection

```@example
using OceanSonar
using CairoMakie

@kwdef struct Case
    family::Symbol
    axis::Axis
    θ₁ = range(0, π/2, 301)
    ρ₁ = [1e3]
    c₁ = [1500.0]
    α₁ = [0.0]
    c₂ₚ = [1600.0]
    c₂ₛ = [0.0]
    α₂ₚ = [0.5]
    α₂ₛ = [0.0]
    ρ₂ = [2e3]
end

fig = Figure()

cases = [
    Case(
        family = :c₂ₚ,
        axis = Axis(fig[1, 1], title = "Celerity"),
        c₂ₚ = Float64[1550 1600 1800],
    )
    Case(
        family = :α₂ₚ,
        axis = Axis(fig[1, 2], title = "Attenuation"),
        α₂ₚ = Float64[0 0.5 1],
    )
    Case(
        family = :ρ₂,
        axis = Axis(fig[2, 1], title = "Density"),
        ρ₂ = Float64[1500 2000 2500],
    )
    Case(
        family = :c₂ₛ,
        axis = Axis(fig[2, 2], title = "Shear Celerity"),
        c₂ₛ = Float64[0 200 400 600],
        α₂ₚ = [0.0]
    )
]

translate_inputs = (
    ρ_inc = :ρ₁,
    ρ_rfr = :ρ₂,
    c_inc = :c₁,
    c_compr_rfr = :c₂ₚ,
    c_shear_rfr = :c₂ₛ,
    α_inc = :α₁,
    α_compr_rfr = :α₂ₚ,
    α_shear_rfr = :α₂ₛ,
    θ_inc = :θ₁
)

model = :rayleigh_solid

for case in cases
    inputs = Tuple(
        getproperty(case, translate_inputs[input])
        for input in list_inputs(reflection_coefficient, model)
    )
    R = @. reflection_coefficient(model, inputs...)
    BRLs = @. -20log10(R |> abs)

    for (n, BRL) in BRLs |> eachcol |> enumerate
        lines!(case.axis, case.θ₁ .|> rad2deg, BRL,
            label = getproperty(case, case.family)[n] |> string
        )
    end

    ylims!(case.axis, 0, 15)
    xlims!(case.axis, 0, 90)
    axislegend(case.axis)
end

save("jensen_fig_1_23.svg", fig)
```

![Replication of Figure 1.23 of Jensen, et al (2011)](jensen_fig_1_23.svg)
