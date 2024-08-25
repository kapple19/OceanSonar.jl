using OceanSonar
using Symbolics

@variables x z
ocean_celerity("Munk", x, z) |> string