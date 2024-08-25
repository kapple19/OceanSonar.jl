using OceanSonar
using Test
using Aqua
using JET
using PropCheck

function test_type_stability(
    func::Union{Function, Type{<:OceanSonar.OcnSon}},
    ::Type{T}
) where T <: OceanSonar.OcnSon
    for model in list_models(func)
        @testset "$model" verbose = true begin
            @test func(model) isa T
        end
    end
end

@testset "OceanSonar.jl" verbose = true begin
    @testset "Code Quality (Aqua.jl)" begin
        Aqua.test_all(OceanSonar, ambiguities = false)
    end
    @testset "Code Linting (JET.jl)" begin
        JET.test_package(OceanSonar; target_defined_modules = true)
    end
    @testset "Code Ambiguities (Test.jl)" begin
        ambiguities = Test.detect_ambiguities(OceanSonar)
        @test length(ambiguities) == 0
    end
    
    include("auxiliary/root.jl")
    include("oceanography/root.jl")
    include("acoustics/root.jl")
end