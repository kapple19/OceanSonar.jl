using OceanSonar
using Test
using InteractiveUtils

function test_type_stability(::Type{T}) where T <: OceanSonar.OcnSon
    for model in list_models(T)
        @testset "$model" begin
            @test T(model) isa T
        end
    end
end

for type in subtypes(OceanSonar.Functor)
    if isconcretetype(type)
        @testset "$type" verbose = true test_type_stability(type)
    else
        for subtype in subtypes(type)
            @testset "$subtype" verbose = true test_type_stability(subtype)
        end
    end
end