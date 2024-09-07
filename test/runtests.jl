using Test
using SafeTestsets
using Base: Fix1

@testset verbose = true "OceanSonar.jl" begin
    name = "Code Quality"
    @time @testset "$name" begin
        @info "Testing $name"
        # testpath = Fix1(joinpath, "00_code_quality") # doesn't work with `@safetestset`
        @safetestset "Aqua" include("00_code_quality/aqua.jl")
        @safetestset "Linting" include("00_code_quality/linting.jl")
        @safetestset "Docstrings" include("00_code_quality/docstrings.jl")
    end

    name = "Preamble"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "Text Styles" include("00_preamble/textstyles.jl")
    end
end
