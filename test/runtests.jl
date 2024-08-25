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

    name = "Generic Implementations"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "String Cases" include("01_pre/01_general/string_cases.jl")
    end

    name = "Ocean Acoustics"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "Dimensional Stability" include("03_acoustics/01_scenario_suite/01_parameters/dimensional_stability.jl")
        @safetestset "Acoustic Tracing" include("03_acoustics/04_propagation/trace.jl")
    end

    name = "Sonar Signal Processing"
    @time @testset "$name" begin
        @info "Testing $name"
        @safetestset "Sonar Types" include("04_processing/01_sonar_types.jl")
    end
end
