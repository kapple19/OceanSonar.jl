beam_reflection_curvature_sign(::ModelName{:surface}) = -1
beam_reflection_curvature_sign(::ModelName{:bottom}) = 1

function reflect!(ntg::ODEIntegrator, vars::NamedTuple, pars::NamedTuple, ctx::Tuple{Symbol, <:Function, <:Function, <:Function})
    r = ntg.u[vars.r]
    z = ntg.u[vars.z]
    ξ = ntg.u[vars.ξ]
    ζ = ntg.u[vars.ζ]
    A = ntg.u[vars.A]
    φ = ntg.u[vars.φ]
    p = ntg.u[vars.p_re] + im * ntg.u[vars.p_im]
    q = ntg.u[vars.q_re] + im * ntg.u[vars.q_im]

    ntf = ctx[1]
    c_ocn = ctx[2]
    z_bty = ctx[3]
    R_btm = ctx[4]

    dz_dr_bty_func(r′) = ForwardDiff.derivative(z_bty, r′)
    dz_dr_bty = dz_dr_bty_func(r)

    θ_bnd_deg = dz_dr_bty |> atand
    θ_inc_deg = atand(ζ, ξ)
    θ_rfl_deg = reflection_angle_degrees(θ_bnd_deg, θ_inc_deg)

    c = c_ocn(r, z)
    ∇c = [
        ForwardDiff.derivative(r′ -> c_ocn(r′, z), r)
        ForwardDiff.derivative(z′ -> c_ocn(r, z′), z)
    ]

    κ = ForwardDiff.derivative(dz_dr_bty_func, r) / (1 + dz_dr_bty^2)^(3/2)

    t⃗_ray = c * [ξ, ζ]
    n⃗_ray = [-t⃗_ray[2], t⃗_ray[1]]

    t⃗_bnd = cossind(θ_bnd_deg)
    n⃗_bnd = [-t⃗_bnd[2], t⃗_bnd[1]]

    α = dot(t⃗_ray, n⃗_bnd)
    β = dot(t⃗_ray, t⃗_bnd)

    cₛ = dot(∇c, t⃗_ray)
    cₙ = dot(∇c, n⃗_ray)

    M = β / α
    N = 2(
        beam_reflection_curvature_sign(ntf |> ModelName) * κ/α + M * (
            2cₙ - cₛ * M
        )
    ) / c^2

    R = (θ_inc_deg - θ_bnd_deg) |> abs |> R_btm

    ntg.u[[vars.ξ, vars.ζ]] .= cossind(θ_rfl_deg) ./ c
    ntg.u[[vars.A, vars.φ]] .= [A * abs(R), φ + angle(R)]
    ntg.u[[vars.p_re, vars.p_im]] .= reim(p + q * N)

    nothing
end

