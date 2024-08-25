### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 5934500e-fbe3-11ea-3ea2-e7f2c1cf9359
begin
	using Plots; gr()
	using ForwardDiff
	using DifferentialEquations
	using LinearAlgebra
	using Interpolations
end

# ╔═╡ 80a89f0e-fc02-11ea-3924-a11494022a97
md"""
# Ray Tracing
This notebook is completely self-contained. It solves the eikonal equation for tracing rays in a cylindrically-symmetric ocean environment, as a 2D slice of ocean (ocn). It includes the bathymetry (bty), the altimetry (ati) and variable ocean sound speed, all range and depth dependent.

The eikonal equation has been expressed in terms of path-length as a system of first order ODEs. This enables simple utilization of the `DifferentialEquations.jl` package. 

For $r$ the range, $z$ the depth, $c(r, z)$ the sound speed field, $s$ the path length along the ray, and $(\xi, \zeta)$ a tangent to the ray, the equations are

```math
\newcommand{\Dif}[2]{\frac{d{#1}}{d{#2}}}
\newcommand{\Part}[2]{\frac{\partial{#1}}{\partial{#2}}}
\begin{aligned}
\Dif{r}{s} &= c(r, z) \xi(s) &
\Dif{\xi}{s} &= \frac{-1}{c(r, z)^2} \Part{c}{r} \\
\Dif{z}{s} &= c(r, z) \zeta(s) &
\Dif{\zeta}{s} &= \frac{-1}{c(r, z)^2} \Part{c}{z}
\end{aligned}
```

The functionality demonstrated here has been successfully run without `struct`s. This notebook is my attempt to port that working code to a function that takes in `struct`s.
"""

# ╔═╡ b36b0080-fcd1-11ea-15af-ad663e45143d
# PlutoUI.TableOfContents()

# ╔═╡ a47ae3c0-fc03-11ea-2322-a5e2ddd51990
md"## Augmenting Code"

# ╔═╡ 735054c0-fc02-11ea-10fe-0b7a22aa8dca
md"### Preamble"

# ╔═╡ e9036770-fc02-11ea-3e27-379927eec193
md"### Generic Variables and Augmenting Functions"

# ╔═╡ 9cc6fab2-fbe5-11ea-2b09-cfb7ec9c627f
begin
	rPeak = 5e3
	rMax = 10e3
	zMax = 1e3
	zMin = 8e2
	zAtiMin = -10
	zAtiMax = 50
	r = range(0, rMax, length = 100)
	z = range(zAtiMin, zMax, length = 51)
end

# ╔═╡ e6961940-fcb8-11ea-2bfa-f32a7d60f480
begin
	function InterpolatingFunction(rng, val)
		Itp = LinearInterpolation(rng, val, extrapolation_bc = Flat())
		return ItpFcn(r) = Itp(r)
	end
	
	function InterpolatingFunction(rng, dpt, val)
		display(rng)
		display(dpt)
		Itp = LinearInterpolation((dpt, rng), val, extrapolation_bc = Flat())
		return ItpFcn(r, z) = Itp(z, r)
	end
end

# ╔═╡ f43d8cb0-fc02-11ea-2271-0dca2ac46977
md"### Ocean Environment: Functions and Structs"

# ╔═╡ 8e0bc300-fbfb-11ea-374f-9bcf6e06ba54
"""
	t_rfl::Vector = boundary_reflection(t_inc::Vector, t_bnd::Vector)

`t_inc`    tangent vector of incident ray
`t_bnd`    tangent vector of boundary
`t_rfl`    tangent vector of reflected ray
"""
function boundary_reflection(t_inc::Vector, t_bnd::Vector)
	n_bnd = [-t_bnd[2], t_bnd[1]]
# 	t_rfl = t_inc - 2(t_inc ⋅ n_bnd)*n_bnd
	t_rfl = t_inc - 2LinearAlgebra.dot(t_inc, n_bnd)*n_bnd
	println(t_inc)
	println(t_bnd)
	println(t_rfl)
	return t_rfl
end

# ╔═╡ 17994f60-fbe4-11ea-1bd3-3925f7a09733
begin
	"""
		Boundary(z)

	`z(r)`    depth of boundary in terms of range `r`
	"""
	struct Boundary
		z::Function
		dzdr::Function
		condition::Function
		affect!::Function
	end
	function Boundary(z::Function)
		dzdr(r) = ForwardDiff.derivative(z, r)
		condition(u, t, ray) = z(u[1]) - u[2]
		affect!(ray) = ray.u[3], ray.u[4] = boundary_reflection([ray.u[3], ray.u[4]], [1, dzdr(ray.u[1])])
		return Boundary(z, dzdr, condition, affect!)
	end
	function Boundary(rz::AbstractArray)
		r_ = [rng for rng ∈ rz[:, 1]]
		z_ = [dpt for dpt ∈ rz[:, 2]]
		zFcn = InterpolatingFunction(r_, z_)
		return Boundary(zFcn)
	end
	function Boundary(z::Real)
		zFcn(r) = z
		return Boundary(zFcn)
	end
end

# ╔═╡ e4ad3740-fc03-11ea-3cec-27b6ed6a7704
md"""
#### Bathymetry
A Gaussian seabed shape is chosen.
"""

# ╔═╡ 82b8dd10-fbe4-11ea-292c-710024b9f9eb
begin
	Aᵣ = (2rPeak/3)^2/log((9zMax - 11zMin)/(10(zMax - zMin)))
	zBty(r) = zMax - (zMax - zMin)*exp(-(r - rPeak)^2/4e5)
	bty = Boundary(zBty)
end

# ╔═╡ 9b62f350-fbe4-11ea-2bd8-a99db7360093
begin
	pBty = plot(r, bty.z,
		legend = false,
		yaxis = (:flip, (0, zMax), raw"$z$"),
		title = "Bathymetry")
	pdBty = plot(r, bty.dzdr,
		legend = false,
		yaxis = (:flip, raw"$\partial{z}/\partial{r}$"),
		xaxis = "Range (m)")
	lBty = @layout [a; b]
	plot(pBty, pdBty, layout = lBty)
end

# ╔═╡ f2713bb0-fc03-11ea-1213-0f56f7df8683
md"""
#### Altimetry
A sinusoidal sea surface is chosen.
"""

# ╔═╡ 46a62e80-fbe5-11ea-3dd8-014cec82f60f
begin
	zAti(r) = zAtiMin + (zAtiMax - zAtiMin)*(sin(r/1e3) + 1.)/2
	ati = Boundary(zAti)
end

# ╔═╡ 97152790-fbe5-11ea-1ca6-a5018f9e1228
begin
	pAti = plot(r, ati.z,
		legend = false,
		yaxis = (:flip, (zAtiMin, zMax), raw"$z$"),
		title = "Altimetry")
	pdAti = plot(r, ati.dzdr,
		legend = false,
		yaxis = (:flip, raw"$\partial{z}/\partial{r}$"),
		xaxis = raw"$r$")
	lAti = @layout [a; b]
	plot(pAti, pdAti, layout = lAti)
end

# ╔═╡ 0c53d1f0-fc04-11ea-1996-c50e9f3050f4
md"#### Ocean Sound Speed"

# ╔═╡ cb5709b0-fbdb-11ea-1d9b-375f555a2a8f
begin
	"""
		Medium(c, R)

	`c(r, z)`    sound speed at range `r` and depth `z`
	`R`          maximum range of slice
	"""
	struct Medium
		c::Function
		∂c∂r::Function
		∂c∂z::Function
		R::Real
	end
	function Medium(c::Function, R::Real)
		c_(x) = c(x[1], x[2])
		∇c_(x) = ForwardDiff.gradient(c_, x)
		∇c(r, z) = ∇c_([r, z])
		∂c∂r(r, z) = ∇c(r, z)[1]
		∂c∂z(r, z) = ∇c(r, z)[2]
		return Medium(c, ∂c∂r, ∂c∂z, R)
	end
	function Medium(c::AbstractArray, R::Real)
		r_ = [rc for rc ∈ c[1, 2:end]]
		z_ = [zc for zc ∈ c[2:end, 1]]
		c_ = c[2:end, 2:end]
		
		cFcn = InterpolatingFunction(r_, z_, c_)
		return Medium(cFcn, R)
	end
	function Medium(c::Real, R::Real)
		cFcn(r, z) = c
		return Medium(cFcn, R)
	end
end

# ╔═╡ 0ff87620-fbe7-11ea-0ef0-6b827f36c4a5
begin
	cMin = 1500
	cMax = 1600
	C(r) = [1 zAti(r) zAti(r)^2
		1 (zAti(r) + zBty(r))/2 ((zAti(r) + zBty(r))/2)^2
		1 zBty(r) zBty(r)^2]
	C_(r) = C(r)\[cMax, cMin, cMax]
	c₀(r) = C_(r)[1]
	c₁(r) = C_(r)[2]
	c₂(r) = C_(r)[3]
	c(r, z) = c₀(r) + c₁(r)*z + c₂(r)*z^2
	ocn = Medium(c, rMax)
end

# ╔═╡ 41932180-fbe7-11ea-05be-15c01a179539
begin
	pc = heatmap(r, z, ocn.c,
		yaxis = (:flip, raw"$z$"),
		title = "Celerity")
	plot!(r, zBty, color = :red, label = "")
	plot!(r, zAti, color = :white, label = "")
	pdcr = heatmap(r, z, ocn.∂c∂r,
		yaxis = (:flip, raw"$z$"))
	plot!(r, zBty, color = :red, label = "")
	plot!(r, zAti, color = :white, label = "")
	pdcz = heatmap(r, z, ocn.∂c∂z,
		yaxis = (:flip, raw"$z$"),
		xaxis = raw"$r$")
	plot!(r, zBty, color = :red, label = "Bathymetry")
	plot!(r, zAti, color = :white, label = "Altimetry")
	
	lc = @layout [a; b; c]
	plot(pc, pdcr, pdcz, layout = lc)
end

# ╔═╡ 694b88f0-fc07-11ea-2f5b-93fcfa7c1463
md"I've designed the sound speed to be parabolic but varying with range such that the maximum value of $cMax is at the boundaries, and $cMin is halfway between."

# ╔═╡ fcc629b0-fc06-11ea-3eaa-adf50eadbce0
begin
	pcAtAti = plot(r, r -> c(r, zAti(r)),
		yaxis = raw"$c\left(r, z_\textrm{ati}\right)$",
		legend = false)
	pcAtHalf = plot(r, r -> c(r, (zBty(r) + zAti(r))/2),
		yaxis = raw"$c\left(r, \frac{z_\textrm{ati} + z_\textrm{bty}}{2}\right)$",
		legend = false)
	pcAtBty = plot(r, r -> c(r, zBty(r)),
		yaxis = raw"$c\left(r, z_\textrm{bty}\right)$",
		xaxis = raw"$r$",
		legend = false)
	lcAt = @layout [a; b; c]
	plot(pcAtAti, pcAtHalf, pcAtBty, layout = lcAt)
end

# ╔═╡ 19e1f950-fc04-11ea-1287-5b8d3307de12
md"#### Sound Source"

# ╔═╡ bcdf3810-fbfb-11ea-015c-998ab7c3d380
"""
	Entity(r, z, θ)

`r`    range of entity
`z`    depth of entity
`θ`    angle of ray
"""
struct Entity
	r::Real
	z::Real
end

# ╔═╡ 84f01650-fc0e-11ea-2861-079e697543db
begin
	r₀ = 0.0
	z₀ = (zBty(r₀) + zAti(r₀))/2
	src = Entity.(r₀, z₀)
end

# ╔═╡ 0ca4cd90-fc03-11ea-3d70-03cf319100f2
md"""
## Acoustic Propagation
The solution implementation is similar to the general Julia differential equation solution form of first defining the problem, then computing the solution.
"""

# ╔═╡ 4d44d700-fc03-11ea-1914-e30845160f20
md"### Problem"

# ╔═╡ 3d33d420-fbe9-11ea-3bc2-bd9475b53a2e
function acoustic_propagation_problem(
		θ₀::Real,
		Src::Entity,
		Ocn::Medium,
		Bty::Boundary,
		Ati::Boundary)
	
	function eikonal!(du, u, p, s)
		r = u[1]
		z = u[2]
		ξ = u[3]
		ζ = u[4]
		τ = u[5]
		du[1] = dr = Ocn.c(r, z)*ξ
		du[2] = dz = Ocn.c(r, z)*ζ
		du[3] = dξ = -Ocn.∂c∂r(r, z)/Ocn.c(r, z)^2
		du[4] = dζ = -Ocn.∂c∂z(r, z)/Ocn.c(r, z)^2
		du[5] = dτ = 1/Ocn.c(r, z)
	end
	
	rng_condition(u, t, ray) = Ocn.R/2 - abs(u[1] - Ocn.R/2)
	rng_affect!(ray) = terminate!(ray)
	CbRng = ContinuousCallback(rng_condition, rng_affect!)
	CbBty = ContinuousCallback(Bty.condition, Bty.affect!)
	CbAti = ContinuousCallback(Ati.condition, Ati.affect!)
	CbBnd = CallbackSet(CbRng, CbBty, CbAti)
	
	r₀ = Src.r
	z₀ = Src.z
	ξ₀ = cos(θ₀)/Ocn.c(r₀, z₀)
	ζ₀ = sin(θ₀)/Ocn.c(r₀, z₀)
	τ₀ = 0.
	u₀ = [r₀, z₀, ξ₀, ζ₀, τ₀]
	
	TLmax = 100
	S = 10^(TLmax/10)
	sSpan = (0., S)
	
	prob_eikonal = ODEProblem(eikonal!, u₀, sSpan)
	
	return prob_eikonal, CbBnd
end

# ╔═╡ 3e7f8f30-fc03-11ea-0f07-bd4c7b8e7ce2
md"### Solution"

# ╔═╡ 78232bd0-fbfd-11ea-0de5-7fb83321c1f0
function solve_acoustic_propagation(prob_eikonal, CbBnd)
	@time RaySol = solve(prob_eikonal, callback = CbBnd)
	return RaySol
end

# ╔═╡ d268f650-fc0d-11ea-151e-fd59c8065050
struct Ray
	θ₀
	Sol
	function Ray(θ₀, Src::Entity, Ocn::Medium, Bty::Boundary, Ati::Boundary)
		Prob, CbBnd = acoustic_propagation_problem(θ₀, Src, Ocn, Bty, Ati)
		Sol = solve_acoustic_propagation(Prob, CbBnd)
		return new(θ₀, Sol)
	end
end

# ╔═╡ 6bf42d00-fc02-11ea-0cc1-27333ef247b9
md"""
### Single Ray
Here we demonstrate the working code for a single ray.
"""

# ╔═╡ a9618660-fbfd-11ea-0c25-3bdaf8e181d2
begin
	θ₀ = acos(c(r₀, z₀)/cMax)
	ray = Ray(θ₀, src, ocn, bty, ati)
end

# ╔═╡ bbc9d5d0-fc0e-11ea-0187-a3a914b19d12
begin
	plot(r, zAti, label = "Altimetry")
	plot!(r, zBty, label = "Bathymetry")
	plot!(ray.Sol, vars = (1, 2), yaxis = :flip, label = "")
end

# ╔═╡ 5c903430-fc02-11ea-28fd-df2119a5b104
md"""
### Multirays
Next we demonstrate the working code for multiple rays. Hopefully this can work via broadcasting.
"""

# ╔═╡ 5ac1f0f0-fc0f-11ea-0d9f-d17ef57c699c
begin
	Base.broadcastable(m::Entity) = Ref(m)
	Base.broadcastable(m::Medium) = Ref(m)
	Base.broadcastable(m::Boundary) = Ref(m)
end

# ╔═╡ 08d817b0-fc0f-11ea-375d-4154a74e15ef
rays = Ray.(θ₀.*(-1.5:0.125:1.5), src, ocn, bty, ati)

# ╔═╡ 72debb50-fc0f-11ea-2192-77bcc5c839f0
begin
	pt = plot(yaxis = :flip)
	plot!(r, zAti, label = "Altimetry")
	plot!(r, zBty, label = "Bathymetry")
	for nRay = 1:length(rays)
		plot!(rays[nRay].Sol, vars = (1, 2), label = "")
	end
	pt
end

# ╔═╡ cb685e02-fcbb-11ea-2e8a-43da1616798e
md"""
### Interpolation
Now we take in vectors of values for the range and depth dependent ocean elements.
"""

# ╔═╡ 26609b80-fcbf-11ea-13f7-71bbfc3d08b3
begin
	rVec = [0, 10, 20, 50, 100, 200, 500, 1e3, 2e3, 5e3, 1e4]
	zVec = [0, 10, 20, 100, 500, 1e3]
end

# ╔═╡ 36f265f2-fcbf-11ea-1d21-87106ecdf10e
md"#### Ocean Sound Speed"

# ╔═╡ 28d91cf0-fcbc-11ea-0b90-41e002050d51
begin
	cMat_ = [1550 + sin(r/1e2) + sin(z/1e2) for z ∈ zVec, r ∈ rVec]
	cMat = vcat(hcat(0, transpose(rVec)), hcat(zVec, cMat_))
end

# ╔═╡ 989d5e10-fcbd-11ea-2e0e-5f918774e04b
heatmap(rVec, zVec, cMat_, yaxis = :flip)

# ╔═╡ 3bf2a3b0-fcbc-11ea-0f1b-73c25779bc06
ocnMat = Medium(cMat, rMax)

# ╔═╡ a586af60-fcbc-11ea-110b-7de105f36ff7
begin
	rNew = range(0, rVec[end], length = 201)
	zNew = range(0, zVec[end], length = 101)
	pcMat = heatmap(rNew, zNew, ocnMat.c, yaxis = :flip)
end

# ╔═╡ d41640d0-fcc0-11ea-20f8-6fd11922f72b
heatmap(rNew, zNew, ocnMat.∂c∂r)

# ╔═╡ 4644ab80-fcbf-11ea-3140-f1b695b3b20d
md"#### Ocean Boundaries"

# ╔═╡ 4fd36aae-fcbf-11ea-0017-ad3e19160af2
begin
	zAtiVec_ = [10(1 - sin(r/2e3)) for r ∈ rVec]
	zAtiVec = hcat(rVec, zAtiVec_)
end

# ╔═╡ a805e35e-fcc0-11ea-0efd-cf82b90f857b
atiVec = Boundary(zAtiVec)

# ╔═╡ d0d4f880-fcc0-11ea-2ca2-5f761b9af8d9
begin
	scatter(rVec, zAtiVec_)
	plot!(rNew, atiVec.z)
end

# ╔═╡ 3b145f60-fcc1-11ea-25d0-332f3ad41f3a
begin
	zBtyVec_ = [zVec[end] - 10sin(r/1e2)^2 for r ∈ rVec]
	zBtyVec = hcat(rVec, zBtyVec_)
end

# ╔═╡ 9defd650-fcc1-11ea-17f0-9752875085d2
btyVec = Boundary(zBtyVec)

# ╔═╡ b282b6a0-fcc1-11ea-24be-09f82bb1cbc4
begin
	scatter(rVec, zBtyVec_)
	plot!(rNew, btyVec.z)
end

# ╔═╡ d720a530-fcc1-11ea-0afb-0df93dd0d9a4
begin
	srcVec = Entity(0.0, 500.)
	θ₀Vec = π/5 .*(-1.5:0.125:1.5)
# 	θ₀Vec = π/5*(-0.125) # issue
end

# ╔═╡ 1c594990-fcc2-11ea-02fb-c36fcef2e847
raysVec = Ray.(θ₀Vec, srcVec, ocnMat, btyVec, atiVec)

# ╔═╡ 58cc1bb0-fcd0-11ea-0c35-7d16b2ce2599
md"Notice a few incorrect rays penetrating the boundaries, but reflecting back."

# ╔═╡ c0b2c252-fccc-11ea-3a60-352b68b6ccc7
begin
	ptVec = plot(yaxis = :flip)
	plot!(rVec, zAtiVec_, label = "Altimetry")
	plot!(rVec, zBtyVec_, label = "Bathymetry")
	for nRay = 1:length(raysVec)
		plot!(raysVec[nRay].Sol, vars = (1, 2), label = "")
	end
# 	plot!(raysVec.Sol, vars = (1, 2), label = "")
	ptVec
end

# ╔═╡ 1a08af90-fcd2-11ea-10a3-9510b86fa7b9
md"""
### Range and Depth Independent
And finally, we demonstrate constancy for the ocean environment.
"""

# ╔═╡ 35b900f0-fcd2-11ea-34bb-796f1eaa7948
begin
	atiConst = Boundary(0)
	btyConst = Boundary(1e3)
	ocnConst = Medium(1500, 1e4)
	srcConst = Entity(0., 1e2)
	θ₀Const = π/4 .*(-1:0.125:1)
end

# ╔═╡ 7e44c7f0-fcd2-11ea-20cf-9bfb3e55d2fc
rayConst = Ray.(θ₀Const, srcConst, ocnConst, btyConst, atiConst)

# ╔═╡ afc386e2-fcd2-11ea-23fb-8d07f25109ed
begin
	pConst = plot(yaxis = :flip)
	for nRay = 1:length(rayConst)
		plot!(rayConst[nRay].Sol, vars = (1, 2), label = "")
	end
	pConst
end

# ╔═╡ Cell order:
# ╟─80a89f0e-fc02-11ea-3924-a11494022a97
# ╠═b36b0080-fcd1-11ea-15af-ad663e45143d
# ╟─a47ae3c0-fc03-11ea-2322-a5e2ddd51990
# ╟─735054c0-fc02-11ea-10fe-0b7a22aa8dca
# ╠═5934500e-fbe3-11ea-3ea2-e7f2c1cf9359
# ╟─e9036770-fc02-11ea-3e27-379927eec193
# ╠═9cc6fab2-fbe5-11ea-2b09-cfb7ec9c627f
# ╠═e6961940-fcb8-11ea-2bfa-f32a7d60f480
# ╟─f43d8cb0-fc02-11ea-2271-0dca2ac46977
# ╠═8e0bc300-fbfb-11ea-374f-9bcf6e06ba54
# ╠═17994f60-fbe4-11ea-1bd3-3925f7a09733
# ╟─e4ad3740-fc03-11ea-3cec-27b6ed6a7704
# ╠═82b8dd10-fbe4-11ea-292c-710024b9f9eb
# ╠═9b62f350-fbe4-11ea-2bd8-a99db7360093
# ╟─f2713bb0-fc03-11ea-1213-0f56f7df8683
# ╠═46a62e80-fbe5-11ea-3dd8-014cec82f60f
# ╠═97152790-fbe5-11ea-1ca6-a5018f9e1228
# ╟─0c53d1f0-fc04-11ea-1996-c50e9f3050f4
# ╠═cb5709b0-fbdb-11ea-1d9b-375f555a2a8f
# ╠═0ff87620-fbe7-11ea-0ef0-6b827f36c4a5
# ╠═41932180-fbe7-11ea-05be-15c01a179539
# ╟─694b88f0-fc07-11ea-2f5b-93fcfa7c1463
# ╠═fcc629b0-fc06-11ea-3eaa-adf50eadbce0
# ╟─19e1f950-fc04-11ea-1287-5b8d3307de12
# ╠═bcdf3810-fbfb-11ea-015c-998ab7c3d380
# ╠═84f01650-fc0e-11ea-2861-079e697543db
# ╟─0ca4cd90-fc03-11ea-3d70-03cf319100f2
# ╟─4d44d700-fc03-11ea-1914-e30845160f20
# ╠═3d33d420-fbe9-11ea-3bc2-bd9475b53a2e
# ╟─3e7f8f30-fc03-11ea-0f07-bd4c7b8e7ce2
# ╠═78232bd0-fbfd-11ea-0de5-7fb83321c1f0
# ╠═d268f650-fc0d-11ea-151e-fd59c8065050
# ╟─6bf42d00-fc02-11ea-0cc1-27333ef247b9
# ╠═a9618660-fbfd-11ea-0c25-3bdaf8e181d2
# ╠═bbc9d5d0-fc0e-11ea-0187-a3a914b19d12
# ╟─5c903430-fc02-11ea-28fd-df2119a5b104
# ╠═5ac1f0f0-fc0f-11ea-0d9f-d17ef57c699c
# ╠═08d817b0-fc0f-11ea-375d-4154a74e15ef
# ╠═72debb50-fc0f-11ea-2192-77bcc5c839f0
# ╟─cb685e02-fcbb-11ea-2e8a-43da1616798e
# ╠═26609b80-fcbf-11ea-13f7-71bbfc3d08b3
# ╟─36f265f2-fcbf-11ea-1d21-87106ecdf10e
# ╠═28d91cf0-fcbc-11ea-0b90-41e002050d51
# ╠═989d5e10-fcbd-11ea-2e0e-5f918774e04b
# ╠═3bf2a3b0-fcbc-11ea-0f1b-73c25779bc06
# ╠═a586af60-fcbc-11ea-110b-7de105f36ff7
# ╠═d41640d0-fcc0-11ea-20f8-6fd11922f72b
# ╟─4644ab80-fcbf-11ea-3140-f1b695b3b20d
# ╠═4fd36aae-fcbf-11ea-0017-ad3e19160af2
# ╠═a805e35e-fcc0-11ea-0efd-cf82b90f857b
# ╠═d0d4f880-fcc0-11ea-2ca2-5f761b9af8d9
# ╠═3b145f60-fcc1-11ea-25d0-332f3ad41f3a
# ╠═9defd650-fcc1-11ea-17f0-9752875085d2
# ╠═b282b6a0-fcc1-11ea-24be-09f82bb1cbc4
# ╠═d720a530-fcc1-11ea-0afb-0df93dd0d9a4
# ╠═1c594990-fcc2-11ea-02fb-c36fcef2e847
# ╟─58cc1bb0-fcd0-11ea-0c35-7d16b2ce2599
# ╠═c0b2c252-fccc-11ea-3a60-352b68b6ccc7
# ╠═1a08af90-fcd2-11ea-10a3-9510b86fa7b9
# ╠═35b900f0-fcd2-11ea-34bb-796f1eaa7948
# ╠═7e44c7f0-fcd2-11ea-20cf-9bfb3e55d2fc
# ╠═afc386e2-fcd2-11ea-23fb-8d07f25109ed
