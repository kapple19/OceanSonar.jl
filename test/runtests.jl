using OceanSonar
using Test
using Aqua
using JET

@testset "OceanSonar.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(OceanSonar)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(OceanSonar; target_defined_modules = true)
    end
    # Write your tests here.
end
