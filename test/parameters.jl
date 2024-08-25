@testset "Parameters" begin
	@info "Parameters"
	Depth = OceanAcoustics.OACBase.Depth
	@testset "Depth" for _ in 1:10
		a, b, c, d = rand(4)
		fcn(r) = a * r^2 - b * exp(-r) + c * sin(r)
		depth_wfcn = Depth(fcn)
		r = unique(sort((1 + d)*rand(20)))
		z = fcn.(r)

		@testset "Inputs" begin
			@testset "Function" begin
				@test depth_wfcn.(r) ≈ z
			end

			@testset "Scalar" begin
				z_scl = 100(rand() - 0.5)
				depth_wscl = Depth(z_scl)
				@test all(depth_wscl.(rand(10)) .== z_scl)
			end

			@testset "Vectors" begin
				depth_wvec = Depth(r, z)
				@test depth_wvec.(r) == z
			end

			@testset "Splat" begin
				depth_wvec_splat = Depth((r, z)...)
				@test depth_wvec_splat.(r) == z
			end
		end

		@testset "Exceptions" begin
			@test_throws DimensionMismatch Depth(r, [z; 10 * rand(3)])
			@test_throws NotSorted Depth([3, 2, 1], [1, 2, 3])
			@test_throws NotAllUnique Depth([1, 1, 2], [1, 2, 3])
		end
	end

	@testset "Reflection Coefficient" begin
		RC = OceanAcoustics.OACBase.ReflectionCoefficient
		@testset "Inputs" begin
			a, b, c, d = rand(4)
			fcn(θ) = a * θ^2 - b * exp(-θ) + c * sin(θ)
			rc_wfcn = RC(fcn)
			θ = π/2 * (21 |> rand |> sort! |> unique!)

			@testset "Function" begin
				@test rc_wfcn.(θ) == fcn.(θ)
			end

			@testset "Scalar" for R in rand(11)
				rc_wscl = RC(R)
				θ = π/2 * (21 |> rand |> sort! |> unique!)
				@test all(rc_wscl.(θ) .== R)
			end

			@testset "Vectors" begin
				R = fcn.(θ)
				rc_wvec = RC(θ, R)
				@test all(rc_wvec.(θ) .== R)
			end

			# @testset "Parameters" begin
				# ρ₁
				# ρ₂
				# c₁
				# cₚ
				# cₛ
				# θ₁
			# end
		end
	end
end