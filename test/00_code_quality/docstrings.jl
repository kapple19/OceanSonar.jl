using OceanSonar
using Test
using Base.Docs

undocd_names = Docs.undocumented_names(OceanSonar, private = true)
@test isempty(undocd_names) skip = true