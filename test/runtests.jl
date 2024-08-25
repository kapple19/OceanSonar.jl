using Test
using SafeTestsets

@testset verbose = true "OceanSonar.jl" begin
    name = "Compilation"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "Compilation" include("00_quality/compilation.jl")
    end

    name = "Code Quality"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "Aqua" include("00_quality/aqua.jl")
        @safetestset "Linting" include("00_quality/linting.jl")
        @safetestset "Docstrings" include("00_quality/docstrings.jl")
    end

    name = "Generic Implementations"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "String Cases" include("01_pre/01_general/string_cases.jl")
    end

    name = "Modelling"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "Dimensional Stability" include("01_pre/02_modelling/dimensional_stability.jl")
    end

    name = "Processing"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "Sonar Types" include("03_processing/01_sonar_types.jl")
    end
end
