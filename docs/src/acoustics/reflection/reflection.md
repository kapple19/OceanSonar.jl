# Boundary Reflection

```@docs
reflection_coefficient
reflections
```

## Rayleigh (Fluid-to-Fluid)

```@docs
OceanSonar.Models.Reflections.rayleigh_fluid
```

## Rayleigh (Fluid-to-Solid)

```@docs
OceanSonar.Models.Reflections.rayleigh_solid
```

```@example
using OceanSonar
using Plots

ρ_ocn = 1_000.0
c_ocn = 1_500.0
α_ocn = 0.0
θ_ocn_deg = 0.0 : 90
θ_ocn = deg2rad.(θ_ocn_deg)

a = let
    c_sbd = Float64[1550 1600 1800]
    c_sbd_shear = 0.0
    α_sbd = 0.5
    α_sbd_shear = 0.0
    ρ_sbd = 2000.0

    R = @. reflection_coefficient("rayleigh_solid",
        c_ocn, c_sbd, c_sbd_shear,
        ρ_ocn, ρ_sbd,
        α_ocn, α_sbd, α_sbd_shear,
        θ_ocn
    )

    BRL = @. -10log10(abs(R))

    plot(θ_ocn_deg, BRL,
        labels = c_sbd,
        title = "(a)"
    )
end

b = let
    c_sbd = 1600.0
    c_sbd_shear = 0.0
    α_sbd = [0 0.5 1.0]
    α_sbd_shear = 0.0
    ρ_sbd = 2000.0

    R = @. reflection_coefficient("rayleigh_solid",
        c_ocn, c_sbd, c_sbd_shear,
        ρ_ocn, ρ_sbd,
        α_ocn, α_sbd, α_sbd_shear,
        θ_ocn
    )

    BRL = @. -10log10(abs(R))

    plot(θ_ocn_deg, BRL,
        labels = α_sbd,
        title = "(b)"
    )
end

c = let
    c_sbd = 1600.0
    c_sbd_shear = 0.0
    α_sbd = 0.5
    α_sbd_shear = 0.0
    ρ_sbd = Float64[1500 2000 2500]

    R = @. reflection_coefficient("rayleigh_solid",
        c_ocn, c_sbd, c_sbd_shear,
        ρ_ocn, ρ_sbd,
        α_ocn, α_sbd, α_sbd_shear,
        θ_ocn
    )

    BRL = @. -10log10(abs(R))

    plot(θ_ocn_deg, BRL,
        labels = ρ_sbd,
        title = "(c)"
    )
end

d = let
    c_sbd = 1600.0
    c_sbd_shear = (0.0 : 200 : 600)'
    α_sbd = 0.0
    α_sbd_shear = 0.0
    ρ_sbd = 2000.0

    R = @. reflection_coefficient("rayleigh_solid",
        c_ocn, c_sbd, c_sbd_shear,
        ρ_ocn, ρ_sbd,
        α_ocn, α_sbd, α_sbd_shear,
        θ_ocn
    )

    BRL = @. -10log10(abs(R))

    plot(θ_ocn_deg, BRL,
        labels = c_sbd_shear,
        title = "(d)"
    )
end

plot(a, b, c, d, layout = (2, 2),
    title = "Repl. Jensen (2011, Fig. 1.23)"
)
```
