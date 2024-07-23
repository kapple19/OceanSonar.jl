using Test
using SafeTestsets

@testset verbose = true "OceanSonar.jl" begin
    name = "Code Quality"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "Aqua" include("00_quality/aqua.jl")
        @safetestset "Linting" include("00_quality/linting.jl")
        @safetestset "Docstrings" include("00_quality/docstrings.jl")
    end
end
