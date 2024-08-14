using OceanSonar
using Test

# Just test they don't error.
buf = IOBuffer()
@test print_tree(buf, SonarType) |> isnothing
@test print_tree(buf, OceanSonar.ModellingType) |> isnothing
@test print_tree(buf, OceanSonar.SpatialDimensionSize) |> isnothing
@test !isempty(buf |> take! |> String)
