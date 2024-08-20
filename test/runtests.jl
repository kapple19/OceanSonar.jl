using Test
using SafeTestsets

@testset verbose = true "OceanSonar.jl" begin
    name = "Code Quality"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "Aqua" include("00_code_quality/aqua.jl")
        @safetestset "Linting" include("00_code_quality/linting.jl")
        @safetestset "Docstrings" include("00_code_quality/docstrings.jl")
    end

    name = "Preamble Tests"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "Text Cases" include("00_preamble/textstyles.jl")
    end
end
