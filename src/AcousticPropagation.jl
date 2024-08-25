"""
	AcousticPropagation

Calculates the sound pressure field for a cylindrical slice of the ocean.

TODO:
2. Define mature plotting function.
	a. Change output type to own struct `Ray`.
	b. Extend base plotting function to plot with `Ray` input?
3. Test ray tracing on scenarios.
	a. Change computation condition to range instead of arc length.
	b. Create mature plotting function.
	c. Convert to structs? Maybe later, for 2.0.
4. Implement amplitude calculation.
5. Produce pressure field output.
6. Combine with sonar equations.
7. Test pressure and TL field on scenarios.
8. Create as formal Julia package 1.0 (or 0.1?) as proof of concept.

Questions:
* How to rename library
* How to do tests for varying parameters?
"""
module AcousticPropagation
using ForwardDiff
using DifferentialEquations
using LinearAlgebra
using Interpolations

export Ray

"""

"""
function InterpolatingFunction(rng, val)
	Itp = LinearInterpolation(rng, val, extrapolation_bc = Flat())
	return ItpFcn(r) = Itp(r)
end

"""

"""
function InterpolatingFunction(rng, dpt, val)
	Itp = LinearInterpolation((dpt, rng), val, extrapolation_bc = Flat())
	return ItpFcn(r, z) = Itp(z, r)
end

"""
	t_rfl::Vector = boundary_reflection(t_inc::Vector, t_bnd::Vector)

`t_inc`    tangent vector of incident ray
`t_bnd`    tangent vector of boundary
`t_rfl`    tangent vector of reflected ray

TODO:
* Reconcile the two versions via error checking.
"""
function boundary_reflection(t_inc::Vector, t_bnd::Vector)
	# works for parabolic boundary
	MyAngle(tng) = atan(tng[2]/tng[1])
	θ_inc = MyAngle(t_inc)
	θ_bnd = MyAngle(t_bnd)

	c = cos(θ_inc)/t_inc[1]

	θ_inc_flat = θ_inc - θ_bnd
	θ_rfl_flat = -θ_inc_flat
	θ_rfl = θ_rfl_flat + θ_bnd

	return [cos(θ_rfl), sin(θ_rfl)]/c
end
# function boundary_reflection(t_inc::Vector, t_bnd::Vector)
# 	# works for generic boundary
# 	n_bnd = [-t_bnd[2], t_bnd[1]]
# # 	t_rfl = t_inc - 2(t_inc ⋅ n_bnd)*n_bnd
# 	t_rfl = t_inc - 2LinearAlgebra.dot(t_inc, n_bnd)*n_bnd

# 	MyAngle(tng) = atand(tng[2]/tng[1])
# 	θ_inc = MyAngle(t_inc)
# 	θ_bnd = MyAngle(t_bnd)
# 	θ_rfl = MyAngle(t_rfl)

# 	# if !isapprox(θ_inc - θ_bnd, θ_bnd - θ_rfl; atol = 1e-6)
# 	# 	println(t_inc)
# 	# 	println(θ_inc)
# 	# 	println(t_bnd)
# 	# 	println(θ_bnd)
# 	# 	println(t_rfl)
# 	# 	println(θ_rfl)
# 	# 	println(θ_inc - θ_bnd)
# 	# 	println(θ_bnd - θ_rfl)
# 	# 	error("Angle calculated incorrectly.")
# 	# end

# 	return t_rfl
# end

"""
	Boundary(z)

`z(r)`    depth of boundary in terms of range `r`
"""
struct Boundary
	z::Function
	dz_dr::Function
	condition::Function
	affect!::Function
	function Boundary(z::Function)
		dz_dr(r) = ForwardDiff.derivative(z, r)
		condition(u, t, ray) = z(u[1]) - u[2]
		affect!(ray) = ray.u[3], ray.u[4] = boundary_reflection([ray.u[3], ray.u[4]], [1, dz_dr(ray.u[1])])
		return new(z, dz_dr, condition, affect!)
	end
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

"""
	Medium(c, R)

`c(r, z)`    sound speed at range `r` and depth `z`
`R`          maximum range of slice
"""
struct Medium
	c::Function
	∂c_∂r::Function
	∂c_∂z::Function
	∂²c_∂r²::Function
	∂²c_∂r∂z::Function
	∂²c_∂z²::Function
	R::Real
	function Medium(c::Function, R::Real)
		c_(x) = c(x[1], x[2])
		∇c_(x) = ForwardDiff.gradient(c_, x)
		∇c(r, z) = ∇c_([r, z])
		∂c_∂r(r, z) = ∇c(r, z)[1]
		∂c_∂z(r, z) = ∇c(r, z)[2]
	
		∂c_∂r_(x) = ∂c_∂r(x[1], x[2])
		∇∂c_∂r_(x) = ForwardDiff.gradient(∂c_∂r_, x)
		∇∂c_∂r(r, z) = ∇∂c_∂r_([r, z])
	
		∂c_∂z_(x) = ∂c_∂z(x[1], x[2])
		∇∂c_∂z_(x) = ForwardDiff.gradient(∂c_∂r_, x)
		∇∂c_∂z(r, z) = ∇∂c_∂z_([r, z])
	
		∂²c_∂r²(r, z) = ∇∂c_∂r(r, z)[1]
		∂²c_∂r∂z(r, z) = ∇∂c_∂r(r, z)[2]
		∂²c_∂z²(r, z) = ∇∂c_∂z(r, z)[2]
	
		return new(c, ∂c_∂r, ∂c_∂z, ∂²c_∂r², ∂²c_∂r∂z, ∂²c_∂z², R)
	end
end
function Medium(c::AbstractArray, R::Real = c[end, 1])
	r_ = [rc for rc ∈ c[1, 2:end]]
	z_ = [zc for zc ∈ c[2:end, 1]]
	c_ = c[2:end, 2:end]
	
	cFcn = InterpolatingFunction(r_, z_, c_)
	return Medium(cFcn, R)
end
function Medium(z::AbstractVector, c::AbstractVector, R = z[end])
	cMat = vcat([0 0 R], hcat(z, c, c))
	return Medium(cMat, R)
end
function Medium(c::Real, R::Real)
	cFcn(r, z) = c
	return Medium(cFcn, R)
end

"""
	Position(r, z, θ)

`r`    range of entity
`z`    depth of entity
"""
struct Position
	r::Real
	z::Real
end

struct Signal
	f::Real
end

struct Source
	Pos::Position
	Sig::Signal
end

function acoustic_propagation_problem(
	θ₀::Real,
	Src::Source,
	Ocn::Medium,
	Bty::Boundary,
	Ati::Boundary)

	function eikonal!(du, u, p, s)
		r = u[1]
		z = u[2]
		ξ = u[3]
		ζ = u[4]
		τ = u[5]
		pʳ = u[6]
		pⁱ = u[7]
		qʳ = u[8]
		qⁱ = u[9]

		∂²c_∂n²(r, z) = Ocn.c(r, z)^2*(
			Ocn.∂²c_∂r²(r, z)*ζ^2
			- 2Ocn.∂²c_∂r∂z(r, z)*ξ*ζ
			+ Ocn.∂²c_∂z²(r, z)*ξ^2
		)

		du[1] = dr_ds = Ocn.c(r, z)*ξ
		du[2] = dz_ds = Ocn.c(r, z)*ζ
		du[3] = dξ_ds = -Ocn.∂c_∂r(r, z)/Ocn.c(r, z)^2
		du[4] = dζ_ds = -Ocn.∂c_∂z(r, z)/Ocn.c(r, z)^2
		du[5] = dτ_ds = 1/Ocn.c(r, z)
		du[6] = dpʳ_ds = ∂²c_∂n²(r, z)/Ocn.c(r, z)^2*qʳ
		du[7] = dpⁱ_ds = ∂²c_∂n²(r, z)/Ocn.c(r, z)^2*qⁱ
		du[8] = dqʳ_ds = Ocn.c(r, z)*pʳ
		du[9] = dqⁱ_ds = Ocn.c(r, z)*pⁱ
	end

	rng_condition(u, t, ray) = Ocn.R/2 - abs(u[1] - Ocn.R/2)
	rng_affect!(ray) = terminate!(ray)
	CbRng = ContinuousCallback(rng_condition, rng_affect!)
	CbBty = ContinuousCallback(Bty.condition, Bty.affect!)
	CbAti = ContinuousCallback(Ati.condition, Ati.affect!)
	CbBnd = CallbackSet(CbRng, CbBty, CbAti)

	r₀ = Src.Pos.r
	z₀ = Src.Pos.z
	ξ₀ = cos(θ₀)/Ocn.c(r₀, z₀)
	ζ₀ = sin(θ₀)/Ocn.c(r₀, z₀)
	τ₀ = 0.0

	λ₀ = Ocn.c(r₀, z₀)/Src.Sig.f
	ω = Src.Sig.f
	p₀ʳ = 1.0
	p₀ⁱ = 0.0
	W₀ = 100λ₀ # 10..50
	q₀ʳ = 0.0
	q₀ⁱ = ω*W₀^2/2

	u₀ = [r₀, z₀, ξ₀, ζ₀, τ₀, p₀ʳ, p₀ⁱ, q₀ʳ, q₀ⁱ]

	TLmax = 100
	S = 10^(TLmax/10)
	sSpan = (0., S)

	prob_eikonal = ODEProblem(eikonal!, u₀, sSpan)

	return prob_eikonal, CbBnd
end

function solve_acoustic_propagation(prob_eikonal, CbBnd)
	@time RaySol = solve(prob_eikonal, callback = CbBnd, reltol=1e-8, abstol=1e-8)
	return RaySol
end

struct Ray
	θ₀
	Sol
	S
	r
	z
	ξ
	ζ
	τ
	p
	q
	θ
	c
	function Ray(θ₀::Real, Src::Source, Ocn::Medium, Bty::Boundary; Ati::Boundary = Boundary(0))
		Prob, CbBnd = acoustic_propagation_problem(θ₀, Src, Ocn, Bty, Ati)
		Sol = solve_acoustic_propagation(Prob, CbBnd)
	
		S = Sol.t[end]
		r(s) = Sol(s, idxs = 1)
		z(s) = Sol(s, idxs = 2)
		ξ(s) = Sol(s, idxs = 3)
		ζ(s) = Sol(s, idxs = 4)
		τ(s) = Sol(s, idxs = 5)
		p(s) = Sol(s, idxs = 6) + im*Sol(s, idxs = 7)
		q(s) = Sol(s, idxs = 8) + im*Sol(s, idxs = 9)
		θ(s) = atan(ζ(s)/ξ(s))
		c(s) = cos(θ(s))/ξ(s)
	
		return new(θ₀, Sol, S, r, z, ξ, ζ, τ, p, q, θ, c)
	end
end

struct Beam
	θ₀::Real
	ray
	b::Function
	S::Real
	function Beam(θ₀::Real, Src::Source, Ocn::Medium, Bty::Boundary, Ati::Boundary = Boundary(0))
		
		ray = Ray(θ₀, Src, Ocn, Bty, Ati)
		
		r(s) = ray.r(s)
		z(s) = ray.z(s)
		τ(s) = ray.τ(s)
		p(s) = ray.p(s)
		q(s) = ray.q(s)
		c(s) = ray.c(s)
		W(s) = sqrt(-2/ω/imag(p(s)/q(s)))
	
		c₀ = c(0)
		ω = 2π*Src.Sig.f
		λ₀ = c₀/Src.Sig.f
		W₀ = W(0)
		q₀ = q(0)
	
		A = 1/c₀ * exp(im*π/4)*sqrt(q₀*ω*cos(θ₀)/2π)
		b_(s, n) = A * sqrt(c(s)/r(s)/q(s)) * exp(-im*ω * (τ(s) + p(s)/q(s)*n^2/2))
		b(s, n) = max(100, b_(s, n))

		return new(θ₀, ray, b, ray.S)
	end
end

# struct Field
# 	θ₀::Union{Real,Vector}
# 	p::Func
# 	function Field(θ₀, Rcv, Src, Ocn, Bty, Before, After)
# 		return new(θ₀, p, TL)
# 	end
# end

# struct FieldCoherent
# 	θ₀::Real
# 	function FieldCoherent(θ₀, Src::Position, Ocn::Medium, Bty::Boundary; Ati::Boundary = Boundary(0))
# 		BeforeSum(p) = p
# 		AfterSum(p) = p
# 		return Field(θ₀, Src, Ocn, Bty, BeforeSum, AfterSum)
# 	end
# end

Base.broadcastable(m::Position) = Ref(m)
Base.broadcastable(m::Medium) = Ref(m)
Base.broadcastable(m::Boundary) = Ref(m)
Base.broadcastable(m::Source) = Ref(m)

end