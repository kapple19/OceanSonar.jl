@testset "Bathymetry" verbose = true begin
    @test list_models(Bathymetry) == list_models(bathymetry)
    @testset "Type Stability" verbose = true test_type_stability(Bathymetry, OceanSonar.Boundary)
end