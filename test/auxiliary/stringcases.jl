@testset "String Cases" begin
    @test OceanSonar.snakecase("Index-Squared Profile") == "index_squared_profile"
end