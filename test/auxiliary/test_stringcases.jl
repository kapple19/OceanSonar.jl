@testset "String Cases" begin
    @test OceanSonar.snakecase("Canonical Deep") == "canonical_deep"
end