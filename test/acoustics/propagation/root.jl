@testset "Propagation" verbose = true begin
    @testset "Consistent Fields" for subtype in subtypes(Propagation)
        @test hasfield(subtype, :x |> Val)
        @test hasfield(subtype, :z |> Val)
        @test hasfield(subtype, :p |> Val)
        @test hasfield(subtype, :PL)
    end
end