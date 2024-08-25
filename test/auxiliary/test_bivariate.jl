@testset "bivariate" begin
	f(x, y) = (3x + y^2) * (sin(x) + cos(y))
	f(x) = f(2x, x/2)
	sorted_random_floats(N) = rand(Float64, N) |> uniquesort!

	@testset "function" begin
		b, x_imp, y_imp = bivariate(f)
		for x = 5sorted_random_floats(10), y = 3sorted_random_floats(10)
			@test b(x, y) == f(x, y)
		end
	end

	@testset "grid" begin
		x = 5sorted_random_floats(100)
		y = 3sorted_random_floats(100)
		Z = [f(x_tmp, y_tmp) for x_tmp in x, y_tmp in y]'
	
		b, x_imp, y_imp = bivariate(x, y, Z)

		@test x == x_imp
		@test y == y_imp

		for (nx, x_loop) = enumerate(x), (ny, y_loop) = enumerate(y)
			rand() > 0.05 && continue
			@test b(x_loop, y_loop) == Z[nx, ny]
		end
	end

	@testset "profiles" begin
		x = 10sorted_random_floats(3)
		yz = [
			[5sorted_random_floats(4) 100sorted_random_floats(4)],
			[5sorted_random_floats(5) 100sorted_random_floats(5)],
			[5sorted_random_floats(6) 100sorted_random_floats(6)]
		]
	
		b, x_imp, y_imp = bivariate(x, yz)

		@test x == x_imp
		for yz_loop in yz
			for y_loop in yz_loop[:, 1]
				@test y_loop in y_imp
			end
		end
		
		for (nx, x_loop) in enumerate(x), (ny, y_loop) in enumerate(yz[nx][:, 1])
			@test b(x_loop, y_loop) == yz[nx][ny, 2]
		end
	end
end