# Flexible Functions

At the time this documentation was written,
[`NaNMath`](https://github.com/JuliaMath/NaNMath.jl)'s functions were not designed for
`Interval`s from [`IntervalArithmetic`](https://docs.sciml.ai/IntervalArithmetic/stable/)
or `Num`s from [`Symbolics`](https://symbolics.juliasymbolics.org/stable/).

[`OceanSonar.Flex`](@ref) is designed to wrap functions of the same names in `NaNMath`
and dispatch to the respectively appropriate "backend" - quoted because
`Num`s and `Interval`s get passed to `Base`.
"Normal" numbers passed to functions in `NaNMath` and `OceanSonar.Flex`
will output `NaN` for invalid inputs
e.g. `sin(-1::Real)` or `sqrt(-1::Real)`,
whereas the equivalent functions in `Base` throw an error.

```@docs
OceanSonar.Flex
```

```@repl
sqrt(-1)
```

```@repl
sqrt(-1 |> complex)
```

```@repl
using OceanSonar # hide
OceanSonar.Flex.sqrt(-1)
```

```@repl
using OceanSonar # hide
OceanSonar.Flex.sqrt(-1 |> complex)
```

```@repl
using OceanSonar, CairoMakie
x = range(-1, 1, 51)
lines(x, x .|> OceanSonar.Flex.sqrt)
```
