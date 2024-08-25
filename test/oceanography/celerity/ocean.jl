@testset "Ocean" verbose = true begin
    @test list_models(OceanCelerity) == list_models(ocean_celerity)
    @testset "Type Stability" verbose = true test_type_stability(OceanCelerity, OceanCelerity)
end