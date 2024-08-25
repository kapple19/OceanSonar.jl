@testset "Atmosphere" verbose = true begin
    @test list_models(AtmosphereCelerity) == list_models(atmosphere_celerity)
    @testset "Type Stability" verbose = true test_type_stability(AtmosphereCelerity, AtmosphereCelerity)
end