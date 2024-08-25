export Beam
export Beams

"""
TODO.
"""
struct Beam <: Result
    s_max::Float64
    s_rfl::Vector{Float64}
    s_hrz::Vector{Float64}

    x::Function
    z::Function
    ξ::Function
    ζ::Function
    p::Function
    θ::Function
    c::Function
end

(beam::Beam)(s::Real, n::Real = 0.0) = beam.p(s, n)

@parse_models_w_args_kwargs Beam

function Beam(model::Val, scen::Scenario; angle)
    beams = Beams(model, scen; angles = [angle])
    return beams[1]
end

list_model_symbols(::Type{Beam}) = list_model_symbols(Beams)

function Beams(
    ::Val{:gaussian},
    scen::Scenario;
    angles = default_angles(scen)
)
    δθ₀ = length(angles) == 1 ? 1.0 : angles |> diff |> mean

    ω = 2π * scen.f

    c_func(x::Real, z::Real) = scen.env.ocn.cel(x, z)
    ∂c_∂x_func(x::Real, z::Real) = derivative(x -> c_func(x, z), x)
    ∂c_∂z_func(x::Real, z::Real) = derivative(z -> c_func(x, z), z)
    ∂²c_∂x²_func(x::Real, z::Real) = derivative(x -> ∂c_∂x_func(x, z), x)
    ∂²c_∂z²_func(x::Real, z::Real) = derivative(z -> ∂c_∂z_func(x, z), z)
    ∂²c_∂x∂z_func(x::Real, z::Real) = derivative(z -> ∂c_∂x_func(x, z), z)
    ∂²c_∂n²_func(x::Real, z::Real, ξ::Real, ζ::Real) = c_func(x, z)^2 * (
        ∂²c_∂x²_func(x, z) * ζ^2
        - 2∂²c_∂x∂z_func(x, z) * ξ * ζ
        + ∂²c_∂z²_func(x, z) * ξ^2
    )

    function trace!(du, u, _, s)
        x, z, ξ, ζ, pRe, pIm, qRe, qIm, τ = u

        c = c_func(x, z)
        c² = c^2
        ∂c_∂x = ∂c_∂x_func(x, z)
        ∂c_∂z = ∂c_∂z_func(x, z)
        ∂²c_∂n² = ∂²c_∂n²_func(x, z, ξ, ζ)

        du[1] = dx_ds = c * ξ
        du[2] = dz_ds = c * ζ
        du[3] = dξ_ds = -∂c_∂x / c²
        du[4] = dζ_ds = -∂c_∂z / c²
        du[5] = dpRe_ds = -∂²c_∂n² * qRe / c²
        du[6] = dpIm_ds = -∂²c_∂n² * qIm / c²
        du[7] = dqRe_ds = c * pRe
        du[8] = dqIm_ds = c * pIm
        du[9] = dτ_ds = 1 / c
    end

    x₀::Float64 = 0.0
    z₀::Float64 = scen.z
    c₀::Float64 = c_func(x₀, z₀)
    λ₀::Float64 = c₀ / scen.f
    W₀::Float64 = 30λ₀
    p₀::ComplexF64 = 1.0 + 0.0im
    q₀::ComplexF64 = 0.0 + im * pi * scen.f * W₀^2
    τ₀::Float64 = 0.0

    R_func(::Altimetry, x, z, θ) = SurfaceReflectionCoefficient(:rayleigh_fluid, scen.env)(x, z, scen.f, θ |> abs)
    R_func(::Bathymetry, x, z, θ) = BottomReflectionCoefficient(:rayleigh_solid, scen.env)(x, z, scen.f, θ |> abs)

    beams = Beam[]
    u₀ = [x₀, z₀, NaN64, NaN64, reim(p₀)..., reim(q₀)..., τ₀]
    u = fill(NaN64, length(u₀))

    for θ₀ in angles
        u₀[3] = ξ₀ = cos(θ₀) / c₀
        u₀[4] = ζ₀ = sin(θ₀) / c₀

        s_rfl = Float64[]
        s_hrz = Float64[]
        R_rfl = ComplexF64[]

        function reflect!(ntg, bnd::Boundary)
            x, z, ξ, ζ = ntg.u[1:4]
            c = c_func(x, z)
            θ = atan(ζ, ξ)

            θ_bnd_deg = derivative(bnd, x) |> atand
            θ_inc_deg = atand(ζ, ξ)
            θ_rfl_deg = reflection_angle_degrees(θ_bnd_deg, θ_inc_deg)

            push!(s_rfl, ntg.t)
            push!(R_rfl, R_func(bnd, x, z, θ))

            ntg.u[3] = cosd(θ_rfl_deg) / c
            ntg.u[4] = sind(θ_rfl_deg) / c

            nothing
        end

        cb_rng = ContinuousCallback(
            (u, _, _) -> u[1] - scen.x,
            terminate!
        )

        cb_ati = ContinuousCallback(
            (u, _, _) -> u[2] - scen.env.ati(u[1]),
            ntg -> reflect!(ntg, scen.env.ati)
        )

        cb_bty = ContinuousCallback(
            (u, _, _) -> u[2] - scen.env.bty(u[1]),
            ntg -> reflect!(ntg, scen.env.bty)
        )

        # cb_hrz = ContinuousCallback(
        #     (u, _, _) -> u[4],
        #     ntg -> push!(s_hrz, ntg.t)
        # ) # "Larger maxiters is needed" message from OrdinaryDiffEq.jl

        # cb = CallbackSet(cb_rng, cb_ati, cb_bty, cb_hrz)
        cb = CallbackSet(cb_rng, cb_ati, cb_bty)

        prob = ODEProblem(trace!, u₀, DEFAULT_RAY_ARC_SPAN)
        sol = solve(prob, Tsit5(), callback = cb)

        s_max = sol.t[end]

        x(s) = sol(s, idxs = 1)
        z(s) = sol(s, idxs = 2)
        ξ(s) = sol(s, idxs = 3)
        ζ(s) = sol(s, idxs = 4)
        θ(s) = atan(ζ(s), ξ(s))
        c(s) = scen.env.ocn.cel(x(s), z(s))

        cumul_refl_coeff(s) = prod(@views R_rfl[s .≤ s_rfl])
        function pressure(s::Real, n::Real)
            !(0 ≤ s ≤ s_max) && return ComplexF64(0.0)

            sol(u, s)

            xVal = u[1]

            xVal < 0 && return ComplexF64(0.0)

            zVal = u[2]
            pVal = complex(u[5], u[6])
            qVal = complex(u[7], u[8])
            τVal = u[9]

            sqrt_arg = c_func(xVal, zVal) / (xVal * qVal)
            exp_arg = -im * ω * (τVal + pVal / 2qVal * n^2)
            A = δθ₀ / c₀ * sqrt(
                q₀ * scen.f * cos(θ₀)
            ) * exp(im * π / 4)
            R = cumul_refl_coeff(s)
            return R * A * sqrt(sqrt_arg) * exp(exp_arg) ::ComplexF64
        end

        beam = Beam(s_max, s_rfl, s_hrz, x, z, ξ, ζ, pressure, θ, c)

        push!(beams, beam)
    end

    return beams
end

@parse_models_w_args_kwargs Beams
