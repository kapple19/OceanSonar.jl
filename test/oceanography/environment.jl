@testset "Environment" verbose = true begin
    @testset "Type Stability" verbose = true test_type_stability(Environment, Environment)
end