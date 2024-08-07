using OceanSonar
using Test

buf = IOBuffer()
@test print_tree(buf, SonarType) |> isnothing
@test print_tree(buf, OceanSonar.ModellingType) |> isnothing
@test print_tree(buf, OceanSonar.EnvironmentComponent) |> isnothing
@test !isempty(buf |> take! |> String)