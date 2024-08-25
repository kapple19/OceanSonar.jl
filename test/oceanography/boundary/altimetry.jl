@testset "Altimetry" verbose = true begin
    @test list_models(Altimetry) == list_models(altimetry)
    @testset "Type Stability" verbose = true test_type_stability(Altimetry, OceanSonar.Boundary)
end