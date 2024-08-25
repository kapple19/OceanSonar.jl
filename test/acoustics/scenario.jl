@testset "Scenario" verbose = true begin
    @testset "Type Stability" verbose = true test_type_stability(Scenario, Scenario)
end