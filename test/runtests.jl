using Test
using OceanAcoustics
using Plots

@testset "OceanAcoustics.jl" begin
    include("scenarios.jl")
    include("parameters.jl")
    include("raytrace/examples.jl")
    include("raytrace/literature.jl")
end

@info "Remember to inspect output plots in `./test/img/`."