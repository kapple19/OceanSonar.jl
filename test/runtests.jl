using Test
using SafeTestsets
using Base: Fix1

@testset verbose = true "OceanSonar.jl" begin
    name = "Code Quality"
    @time @testset "$name" begin
        @info "Testing $name"
        # testpath = Fix1(joinpath, "00_code_quality")
        @safetestset "Aqua" include("00_code_quality/aqua.jl")
        @safetestset "Linting" include("00_code_quality/linting.jl")
        @safetestset "Docstrings" include("00_code_quality/docstrings.jl")
    end

    name = "Auxiliaries"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "NaNMath" include("00_preamble/nanmath.jl")
    end
end
