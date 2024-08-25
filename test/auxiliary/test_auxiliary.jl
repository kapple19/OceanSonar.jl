@testset "auxiliary" begin
    @testset "uniquesort" for _ in 1 : 10
        v = rand(10)
        v = [v; v[1:3]]
        u = uniquesort!(v)
        @test issorted(v)
        @test allunique(v)
    end

    include("test_univariate.jl")
    include("test_bivariate.jl")
end