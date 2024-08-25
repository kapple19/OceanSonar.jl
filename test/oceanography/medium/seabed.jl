@testset "Seabed" verbose = true begin
    @testset "Type Stability" verbose = true test_type_stability(Seabed, OceanSonar.Medium)
end