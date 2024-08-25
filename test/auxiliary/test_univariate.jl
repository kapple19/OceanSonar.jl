@testset "univariate" begin
	f(x, y) = (3x + y^2) * (sin(x) + cos(y))
	f(x) = f(2x, x/2)
    sorted_random_floats(N) = rand(Float64, N) |> uniquesort!

    @testset "function" begin
        u, x_imp = univariate(f)
        for x = 100sorted_random_floats(10)
            @test u(x) == f(x)
        end
    end

    @testset "constant" for _ = 1 : 5
        y = rand(Int) + rand()
        u, x_imp = univariate(y)
        for _ = 1 : 5
            x = rand(Int) + rand()
            @test u(x) == y
        end
    end

	@testset "vectors" begin
		x = 100sorted_random_floats(100) |> uniquesort!
		y = f.(x)
		u, x_imp = univariate(x, y)
		@test x_imp == x
		for (n, x_loop) = enumerate(x)
			@test u(x_loop) == y[n]
		end
	end
end