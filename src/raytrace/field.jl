"""
$(TYPEDEF)

$(TYPEDFIELDS)
"""
struct Ray <: Oac
	"Maximum ray arc length [m]."
	s_max::Float64

	"Ray range [m]. Univariate, called as `r(s::Real)`."
	r::Function

	"Ray depth [m]. Univariate, called as `z(s::Real)`."
	z::Function

	"Ray angle [rad]. Univariate, called as `θ(s::Real)`."
	θ::Function

	"Ray sound celerity [m/s]. Univariate, called as `c(s::Real)`."
	c::Function

	"Ray pressure phase [rad?]. Univariate, called as `τ(s::Real)`."
	τ::Function

	"""
	Ray pressure [Pa]. Has two methods:
	* `p(s::Real) -> ComplexF64` pressure along ray at arc length point `s`.
	* `p(s::Real, n::Real) -> ComplexF64` pressure at normal distance `n` [m] from ray at arc length point `s` [m].
	"""
	p::Function

	"""
	Propagation Loss [dB]. Has two methods:
	* `PL(s::Real) -> Real` propagation loss along ray at arc length point `s`.
	* `PL(s::Real, n::Real) -> Real` propagation loss at normal distance `n` [m] from ray at arc length point `s` [m].
	"""
	PL::Function
end

struct Trace <: Oac
	rays::Vector{Ray}
end

"""
$(TYPEDSIGNATURES)
"""
function Field(scn::Scenario,
	angles::AbstractVector{<:AbstractFloat};
	ranges::AbstractVector{<:AbstractFloat} = default_ranges(scn),
	depths::AbstractVector{<:AbstractFloat} = default_depths(scn),
	save_field::Bool = true,
	save_trace::Bool = false
	)

	if !(save_field || save_trace)
		error("No computation.") # flesh out
	end

	cel(r, z) = scn.env.ocn.c(r, z)
	∂c_∂r(r, z) = derivative(r̂ -> cel(r̂, z), r)
	∂c_∂z(r, z) = derivative(ẑ -> cel(r, ẑ), z)
	∂²c_∂r²(r, z) = derivative(r̂ -> ∂c_∂r(r̂, z), r)
	∂²c_∂z²(r, z) = derivative(ẑ -> ∂c_∂z(r, ẑ), z)
	∂²c_∂r∂z(r, z) = derivative(r̂ -> ∂c_∂z(r̂, z), r)
	∂²c_∂n²(r, z, ξ, ζ) = cel(r, z)^2 * (
		∂²c_∂r²(r, z) * ζ^2
		 - 2 * ∂²c_∂r∂z(r, z) * ξ * ζ
		 + ∂²c_∂z²(r, z) * ξ^2
	)

	δθ₀ = if length(angles) == 1
		1.0
	else
		angles |> diff |> mean
	end

	function tracer!(du, u, params, s)
		r, z, ξ, ζ, τ, pRe, pIm, qRe, qIm = u
		
		c = cel(r, z)
		∂cr = ∂c_∂r(r, z)
		∂cz = ∂c_∂z(r, z)
		∂²cnn = ∂²c_∂n²(r, z, ξ, ζ)

		du[1] = dr = c * ξ
		du[2] = dz = c * ζ
		du[3] = dξ = -∂cr / c^2
		du[4] = dζ = -∂cz / c^2
		du[5] = dτ = 1/c
		du[6] = dpRe = -∂²cnn / c^2 * qRe
		du[7] = dpIm = -∂²cnn / c^2 * qIm
		du[8] = dqRe = c * pRe
		du[9] = dqIm = c * pIm
	end

	f = scn.ent.src.f

	r₀ = 0.0
	z₀ = scn.ent.src.z
	c₀ = cel(r₀, z₀)
	τ₀ = 0.0
	p₀Re = 1.0
	p₀Im = 0.0
	λ₀ = c₀ / f
	W₀ = 30λ₀
	q₀Re = 0.0
	q₀Im = pi * f * W₀^2

	Nr = length(ranges)
	Nz = length(depths)
	pressure = zeros(ComplexF64, Nr, Nz)

	rays = Ray[]

	for θ₀ in angles
		ξ₀ = cos(θ₀) / c₀
		ζ₀ = sin(θ₀) / c₀
		
		u₀ = [r₀, z₀, ξ₀, ζ₀, τ₀, p₀Re, p₀Im, q₀Re, q₀Im]

		s_span = (0.0, 100e3)
	
		s_rfl = [0.0]
		R_rfl = [1.0 + 0.0im]

		function reflect!(int, bnd)
			r, z, ξ, ζ = int.u[1:4]
			c = cel(r, z)
			tng_inc = c * [ξ; ζ]
	
			θ_rfl = reflection(tng_inc, derivative(bnd.z, r))
			push!(s_rfl, int.t)
			push!(R_rfl, bnd.R)
	
			int.u[3] = cos(θ_rfl) / c
			int.u[4] = sin(θ_rfl) / c
		end
	
		cb_rng = ContinuousCallback(
			(x, s, int) -> x[1] - scn.ent.rcv.r,
			terminate!
		)
	
		cb_srf = ContinuousCallback(
			(x, s, int) -> x[2] - scn.env.srf.z(x[1]),
			int -> reflect!(int, scn.env.srf)
		)
	
		cb_btm = ContinuousCallback(
			(x, s, int) -> x[2] - scn.env.btm.z(x[1]),
			int -> reflect!(int, scn.env.btm)
		)
	
		cb = CallbackSet(cb_rng, cb_btm, cb_srf)

		prob = ODEProblem(tracer!, u₀, s_span)
	
		sol = solve(prob, Tsit5(), callback = cb)

		s_max = sol.t[end]
		r(s) = sol(s, idxs = 1)
		z(s) = sol(s, idxs = 2)
		ξ(s) = sol(s, idxs = 3)
		ζ(s) = sol(s, idxs = 4)
		τ(s) = mod(sol(s, idxs = 5), π)
		p(s) = sol(s, idxs = 6) + im * sol(s, idxs = 7)
		q(s) = sol(s, idxs = 8) + im * sol(s, idxs = 9)
		c(s) = cel(r(s), z(s))
		θ(s) = atan(ζ(s) / ξ(s))
		
		R_rfl = [*(R_rfl[begin:n]...) for n = eachindex(R_rfl)]
		ω = 2π * f
		function A(s)
			A₀ = δθ₀ / c(0.0) * sqrt(
				q(0.0) * f * cos(θ₀)
			) * exp(im * π / 4)
			n_rfl = findlast(s_rfl .<= s)
			return A₀ * R_rfl[n_rfl]
		end
		function beam(s::Real, n::Real)
			(s > s_max || s < 0) && return ComplexF64(0.0)
			r(s) < 0 && return ComplexF64(0.0)
			return A(s) * sqrt(
					c(s) / r(s) / q(s)
				) * exp(
				-im * ω * (
					τ(s) + p(s) / 2 / q(s) * n^2
				)
			)
		end
		beam(s::Real) = beam(s, 0.0)
		PL(s::Real, n::Real) = -20log10(beam(s, n) |> abs)
		PL(s::Real) = PL(s, 0.0)

		if save_trace
			push!(rays, Ray(s_max, r, z, θ, c, τ, beam, PL))
		end

		if save_field
			arc = range(0.0, s_max, max(101, floor(Nr/3) |> Int))
			for i = eachindex(arc)[begin+1 : end]
				sᵢ₋₁, sᵢ = arc[i-1 : i]
				rᵢ₋₁, rᵢ = r.([sᵢ₋₁, sᵢ])
				# zᵢ₋₁ = z(sᵢ₋₁)
				zᵢ = z(sᵢ)
				# for (nr, r_grid) in enumerate(ranges)
				# 	if !(rᵢ₋₁ .≤ r_grid .< rᵢ)
				# 		continue
				# 	end
				for nr in findall(rᵢ₋₁ .≤ ranges .< rᵢ)
					r_grid = ranges[nr]
					for (nz, z_grid) in enumerate(depths)
						x_rcv = [r_grid, z_grid]
						# x_ray = [rᵢ₋₁, zᵢ₋₁]
						x_ray = [rᵢ, zᵢ]
						t_ray = c(sᵢ₋₁) * [ξ(sᵢ₋₁), ζ(sᵢ₋₁)]
						t_ray /= dot(t_ray, t_ray) |> sqrt
						n_ray = c(sᵢ₋₁) * [-ζ(sᵢ₋₁), ξ(sᵢ₋₁)]
						n_ray /= dot(n_ray, n_ray) |> sqrt
						s = dot(x_rcv - x_ray, t_ray)
						n = dot(x_rcv - x_ray, n_ray) |> abs
						p_add = beam(sᵢ₋₁ + s, n)
						if !(isnan(p_add) || isinf(p_add))
							pressure[nr, nz] += p_add
						end
					end
				end
			end
		end
	end
	PL = -20log10.(pressure .|> abs)
	PL = max.(0.0, PL)
	PL = min.(100.0, PL)

	fld = OACBase.Field(ranges, depths, PL)
	trc = Trace(rays)

	return if save_trace && save_field
		fld, trc
	elseif save_field
		fld
	elseif save_trace
		trc
	end
end

function Field(scn::Scenario,
	Nangles::Int = 101;
	ranges::AbstractVector{<:Float64} = default_ranges(scn),
	depths::AbstractVector{<:Float64} = default_depths(scn),
	save_field::Bool = true,
	save_trace::Bool = false
	)

	return Field(scn,
		default_angles(scn, Nangles),
		ranges = ranges,
		depths = depths,
		save_field = save_field,
		save_trace = save_trace
	)
end