@testset "Ocean" verbose = true begin
    @testset "Type Stability" verbose = true test_type_stability(Ocean, OceanSonar.Medium)
end