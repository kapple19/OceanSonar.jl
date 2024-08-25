@testset "Seabed" verbose = true begin
    @test list_models(SeabedCelerity) == list_models(seabed_celerity)
    @testset "Type Stability" verbose = true test_type_stability(SeabedCelerity, SeabedCelerity)
end