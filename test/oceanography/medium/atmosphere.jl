@testset "Atmosphere" verbose = true begin
    @testset "Type Stability" verbose = true test_type_stability(Atmosphere, OceanSonar.Medium)
end