export Beam

function gradient2tangent(m::Float64)
	x = 1 / √(m^2 + 1)
	[x; m*x]
end

function reflection(tng_inc::Vector{Float64}, m_bnd::Real)
	m_bnd = Float64(m_bnd)
	tng_bnd = gradient2tangent(m_bnd)
	nrm_bnd = [0 1; -1 0] * tng_bnd
	α = tng_inc' * nrm_bnd # [Jensen et al. eq. 3.118]
	tng_rfl = tng_inc - 2α * nrm_bnd # [Jensen et al. eq. 3.121]
	atan(tng_rfl[2] / tng_rfl[1])
end

struct Beam <: OcnSon
    s_max::Float64
    x::Function
    z::Function
    ξ::Function
    ζ::Function
    p::Function

    function Beam(scen::Scenario, δθ₀::Real, θ₀::Real)
        cel(x, z) = scen.env.ocn.cel(x, z)
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
    
        function tracer!(du, u, _, _)
            r, z, ξ, ζ, _, pRe, pIm, qRe, qIm = u
            
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
    
        f = scen.f
    
        r₀ = 0.0
        z₀ = scen.z
        c₀ = cel(r₀, z₀)
        τ₀ = 0.0
        p₀Re = 1.0
        p₀Im = 0.0
        λ₀ = c₀ / f
        W₀ = 30λ₀
        q₀Re = 0.0
        q₀Im = pi * f * W₀^2
    
        ξ₀ = cos(θ₀) / c₀
        ζ₀ = sin(θ₀) / c₀
        
        u₀ = [r₀, z₀, ξ₀, ζ₀, τ₀, p₀Re, p₀Im, q₀Re, q₀Im]

        s_span = (0.0, 100e3)
    
        s_rfl = [0.0]
        # R_rfl = [1.0 + 0.0im]

        function reflect!(ntg, bnd::Boundary)
            r, z, ξ, ζ = ntg.u[1:4]
            c = cel(r, z)
            tng_inc = c * [ξ; ζ]
    
            θ_rfl = reflection(tng_inc, derivative(bnd, r))
            push!(s_rfl, ntg.t)
            # push!(R_rfl, bnd.R)
    
            ntg.u[3] = cos(θ_rfl) / c
            ntg.u[4] = sin(θ_rfl) / c
        end
    
        cb_rng = ContinuousCallback(
            (x, s, ntg) -> x[1] - scen.x,
            terminate!
        )
    
		cb_ati = ContinuousCallback(
			(x, s, ntg) -> x[2] - scen.env.ati(x[1]),
			ntg -> reflect!(ntg, scen.env.ati)
		)
	
		cb_bty = ContinuousCallback(
			(x, s, ntg) -> x[2] - scen.env.bty(x[1]),
			ntg -> reflect!(ntg, scen.env.bty)
		)
	
		cb = CallbackSet(cb_rng, cb_bty, cb_ati)

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

        ω = 2π * f
        A = δθ₀ * c(0) \ exp(im * π/4) * √(
            q(0) * ω * cos(θ₀) / 2π
        )

        pressure(s, n) = A * √(c(s) / (r(s) * q(s))) * exp(
            -im * ω * (
                τ(s) + p(s) * n^2 / 2q(s)
            )
        )

        new(s_max, r, z, ξ, ζ, pressure)
    end
end