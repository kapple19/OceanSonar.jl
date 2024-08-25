### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ f6f34400-dd3f-11ee-1a23-33af0a082239
begin
	using Pkg

	Pkg.add("ModelingToolkit")
	Pkg.add("OrdinaryDiffEq")
	Pkg.add("Plots")
	Pkg.develop("OceanSonar")

	using ModelingToolkit
	using OrdinaryDiffEq
	using Plots
	using OceanSonar

	Pkg.status()
end

# ╔═╡ 7e349625-b3d6-4e6b-a9d7-7ac032ab4aa9
md"""
# Modeling Toolkit Compatibility
The following code will become part of OceanSonar.jl once the needed features are implemented in ModelingToolkit.jl.

E.g. <https://github.com/SciML/ModelingToolkit.jl/pull/2427>
"""

# ╔═╡ d429c4ad-50cc-47aa-a45e-b0df10d41b43
@mtkmodel Eikonal begin
	begin
		s = only(@parameters s)
	end

	@variables begin
		x(s), [description = "Horizontal range"]
		z(s), [description = "Downward depth"]
		ξ(s), [description = "Normalised horizontal celerity gradient"]
		ζ(s), [description = "Normalised vertical celerity gradient"]
	end

	@structural_parameters begin
		scen
	end

	begin
		D = Differential(s)
		∂c_∂z(x, z) = ModelingToolkit.derivative(c(x, z), z)
		∂c_∂x(x, z) = ModelingToolkit.derivative(c(x, z), x)

		c = scen.slc.ocn.cel
	end

	@continuous_events begin
		[x ~ scen.x] => ((t1, t2, t3, t4) -> terminate!(t1), [], [], [])
		[z ~ 0] => [ζ ~ -ζ]
	end

	@equations begin
		D(x) ~ c(x, z) * ξ
		D(z) ~ c(x, z) * ζ
		D(ξ) ~ -∂c_∂x(x, z) / c(x, z)^2
		D(ζ) ~ -∂c_∂z(x, z) / c(x, z)^2
	end
end

# ╔═╡ d9869488-44db-4a09-a030-1c707c484856
function munk_profile(x, z; ϵ = 7.37e-3)
	z̃ = 2(z - 1300)/1300
	1500(1 + ϵ * (z̃ - 1 + exp(-z̃)))
end

# ╔═╡ 8b79f49d-5486-4bd9-8e6f-c5f74c5579e2
@mtkbuild eik = Eikonal(scen = scen)

# ╔═╡ d32b532c-59c9-4f3c-aebe-4d5eabf69b10
scen = Scenario("Munk Profile")

# ╔═╡ 49b98d31-ce55-47ee-8b27-fed9365c6a6a
@mtkbuild eik_munk = Eikonal(scen = scen)

# ╔═╡ ed059bda-f4a1-462d-91a8-39750ead7926
sol_munk = let
	angle = 0.0
	u0 = [
		0.0
		1e3
		cos(angle) / munk_profile(0.0, 1e3)
		sin(angle) / munk_profile(0.0, 1e3)
	]
	prob = ODEProblem(eik, u0, (0.0, 100e3))
	sol = solve(prob, Tsit5())
end

# ╔═╡ 830f3ff2-f62c-475e-bdd5-ba3772c67dcf
plot(sol_munk, idxs = (:x, :z), yflip = true)

# ╔═╡ 20e37e67-7a97-4598-b6c3-92e021464a53
# function trace(scen::Scenario, angle)
# 	@mtkbuild eik_scen = Eikonal(c = scen.slc.ocn.cel)
# 	x0 = 0.0
# 	z0 = scen.z
# 	u0 = [
# 		x0
# 		z0
# 		cos(angle) / scen.slc.ocn.cel(x0, z0)
# 		sin(angle) / scen.slc.ocn.cel(x0, z0)
# 	]
	
# 	# prob = ODEProblem(eik_scen, u0, OceanSonar.DEFAULT_RAY_ARC_SPAN)
# 	prob = ODEProblem(eik_scen, u0, (0.0, 100e3))
# 	sol = solve(prob, Tsit5())
# end

# ╔═╡ 57041ca1-be9c-41b0-809b-c90dd3874f8b
function trace(scen::Scenario, angle)
	@mtkbuild eik = Eikonal(scen = scen)
	x0 = 0.0
	z0 = scen.z
	u0 = [
		x0
		z0
		cos(angle) / scen.slc.ocn.cel(x0, z0)
		sin(angle) / scen.slc.ocn.cel(x0, z0)
	]
	
	prob = ODEProblem(eik, u0, OceanSonar.DEFAULT_RAY_ARC_SPAN)
	# prob = ODEProblem(eik, u0, (0.0, 250e3);
	# 	continuous_events = [
	# 		[eik.x ~ scen.x] => (terminate!, [], [], [], nothing),
	# 		[eik.z ~ 0] => [eik.ζ ~ -eik.ζ]
	# 	]
	# )
	# prob = ODEProblem(eik, u0, (0.0, 250e3);
	# 	continuous_events = [eik.z ~ 0] => [eik.ζ ~ -eik.ζ]
	# )
	sol = solve(prob, Tsit5())
end

# ╔═╡ 3c6b2229-5ba7-43bf-8fef-f7600a3aba11
sol = trace(scen, -π/4)

# ╔═╡ 17c9a114-90a7-4eeb-a277-98945f289186
plot(sol, idxs = (:x, :z), yflip = true)

# ╔═╡ d9451565-7a71-4be6-90cc-85a1710f43f3
sol2 = trace(scen, -0.25)

# ╔═╡ 2a83e4a1-976e-4e52-8059-5bd0a01fb5e3
plot(sol2, idxs = (:x, :z), yflip = true)

# ╔═╡ 705b54ee-98a9-4df7-afba-43e3317423c9
sols = trace.(scen, critical_angles(scen, N = 21))

# ╔═╡ faea319b-61fe-4f96-a7fc-eed6a2f2b2de
critical_angles(scen, N = 3)

# ╔═╡ d3e843dd-86ab-4aee-b8f7-918055acbc0a
let
	plot()
	plot!.(sols, idxs = (:x, :z))
	plot!(yflip = true, legend = false)
end

# ╔═╡ 7aec2d3d-1b7e-49ff-97b4-9e29d2ef9ae9
let
	plot()
	plot!.(sols, idxs = (:x, :z))
	plot!(yflip = true, legend = false, xlim = (0, 250e3))
end

# ╔═╡ c18f392c-557e-43b3-8644-65aeb78ed837
scen_lcz = Scenario("linearised Convergence Zones");

# ╔═╡ b61be131-2bf2-422f-8a81-fb5980999371
sols_lcz = trace.(scen_lcz, critical_angles(scen_lcz, N = 21));

# ╔═╡ d6bd9ed2-d768-4ea3-beeb-e1aaa5d068c5
let
	plot()
	plot!.(sols_lcz, idxs = (:x, :z))
	plot!(yflip = true, legend = false)
end

# ╔═╡ 1aea1350-51b0-4dc0-a0d6-4f061b8cebb4
names(Symbolics)

# ╔═╡ 1ace5e8a-106c-4dae-a43c-9fcf625418b1
@register_symbolic

# ╔═╡ Cell order:
# ╟─7e349625-b3d6-4e6b-a9d7-7ac032ab4aa9
# ╠═f6f34400-dd3f-11ee-1a23-33af0a082239
# ╠═d429c4ad-50cc-47aa-a45e-b0df10d41b43
# ╠═d9869488-44db-4a09-a030-1c707c484856
# ╠═8b79f49d-5486-4bd9-8e6f-c5f74c5579e2
# ╠═d32b532c-59c9-4f3c-aebe-4d5eabf69b10
# ╠═49b98d31-ce55-47ee-8b27-fed9365c6a6a
# ╠═ed059bda-f4a1-462d-91a8-39750ead7926
# ╠═830f3ff2-f62c-475e-bdd5-ba3772c67dcf
# ╠═20e37e67-7a97-4598-b6c3-92e021464a53
# ╠═57041ca1-be9c-41b0-809b-c90dd3874f8b
# ╠═3c6b2229-5ba7-43bf-8fef-f7600a3aba11
# ╠═17c9a114-90a7-4eeb-a277-98945f289186
# ╠═d9451565-7a71-4be6-90cc-85a1710f43f3
# ╠═2a83e4a1-976e-4e52-8059-5bd0a01fb5e3
# ╠═705b54ee-98a9-4df7-afba-43e3317423c9
# ╠═faea319b-61fe-4f96-a7fc-eed6a2f2b2de
# ╠═d3e843dd-86ab-4aee-b8f7-918055acbc0a
# ╠═7aec2d3d-1b7e-49ff-97b4-9e29d2ef9ae9
# ╠═c18f392c-557e-43b3-8644-65aeb78ed837
# ╠═b61be131-2bf2-422f-8a81-fb5980999371
# ╠═d6bd9ed2-d768-4ea3-beeb-e1aaa5d068c5
# ╠═1aea1350-51b0-4dc0-a0d6-4f061b8cebb4
# ╠═1ace5e8a-106c-4dae-a43c-9fcf625418b1
