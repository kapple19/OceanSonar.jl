using OceanSonar
using Test
using Base.Docs

undocs = undocumented_names(OceanSonar, private = true)
@test_broken undocs |> isempty