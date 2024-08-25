export Fan

const DEFAULT_RAY_ARC_SPAN = (0, 1e6)

function TracingODESystem(
    c_ocn::Function,
    r_max::Real,
    z_bty::Function,
    R_btm::Function,
    z_ati::Function,
    R_srf::Function;
    name
)
    @parameters begin
        s, [description = "Ray arc length"]
    end

    @parameters begin
        θ₀
        c₀
        r₀
        z₀
        ξ₀
        ζ₀
        A₀
        φ₀
        τ₀
        p₀_re
        p₀_im
        q₀_re
        q₀_im
    end

    @variables begin
        θ(s), [description = "Downward ray angle"]
        c(s), [description = "Ocean Sound speed at ray position"]
        # cₛ(s), [description = "tangential sound speed derivative of ray"]
        # cₙ(s), [description = "normal sound speed derivative of ray"]
    end

	deps = @variables begin
		r(s), [description = "Horizontal range of ray"]
		z(s), [description = "Downward depth of ray"]
		ξ(s), [description = "Normalised horizontal gradient of ray"]
		ζ(s), [description = "Normalised vertical gradient of ray"]
        A(s), [description = "Ray amplitude"]
        φ(s), [description = "Ray phase"]
        τ(s), [description = "Ray time"]
        p_re(s), [description = ""]
        p_im(s), [description = ""]
        q_re(s), [description = "Range-normalised ray tube width, real component"]
        q_im(s), [description = "Range-normalised ray tube width, imaginary component"]
	end

    D = Differential(s)

    c²(r′, z′) = c_ocn(r′, z′)^2
    ∂c_∂r(r′, z′) = ModelingToolkit.derivative(c_ocn(r, z′), r′)
    ∂c_∂z(r′, z′) = ModelingToolkit.derivative(c_ocn(r′, z), z′)
    ∂²c_∂r²(r′, z′) = ModelingToolkit.derivative(∂c_∂r(r, z′), r′)
    ∂²c_∂z²(r′, z′) = ModelingToolkit.derivative(∂c_∂z(r′, z), z′)
    ∂²c_∂r∂z(r′, z′) = ModelingToolkit.derivative(∂c_∂z(r, z′), r′)
    ∂²c_∂n²_(r′, z′, ξ′, ζ′) = 2∂²c_∂r∂z(r′, z′) * ξ′ * ζ′ - ∂²c_∂r²(r′, z′) * ζ′^2 - ∂²c_∂z²(r′, z′) * ξ′^2

    eqns = [
		D(r) ~ c_ocn(r, z) * ξ
		D(z) ~ c_ocn(r, z) * ζ
		D(ξ) ~ -∂c_∂r(r, z) / c_ocn(r, z)^2
		D(ζ) ~ -∂c_∂z(r, z) / c_ocn(r, z)^2
        D(A) ~ 0
        D(φ) ~ 0
        D(τ) ~ 1 / c_ocn(r, z)
        D(p_re) ~ ∂²c_∂n²_(r, z, ξ, ζ) * q_re
        D(p_im) ~ ∂²c_∂n²_(r, z, ξ, ζ) * q_im
        D(q_re) ~ -c_ocn(r, z) * p_re
        D(q_im) ~ -c_ocn(r, z) * p_im
        θ ~ atan(ζ, ξ)
        c ~ c_ocn(r, z)
        # cₛ ~ c * (ξ * ∂c_∂r(r, z) + ζ * ∂c_∂z(r, z))
        # cₙ ~ c * (ξ * ∂c_∂z(r, z) - ζ * ∂c_∂r(r, z))
    ]

    maximum_range = [r ~ r_max] => (
        (ntg, _, _, _) -> terminate!(ntg),
        [], [], []
    )

    surface_reflection = [z ~ z_ati(r)] => (
        reflect!,
        [r, z, ξ, ζ, A, φ, p_re, p_im, q_re, q_im],
        [],
        [],
        (:surface, c_ocn, z_ati, R_srf)
    )

    bottom_reflection = [z ~ z_bty(r)] => (
        reflect!,
        [r, z, ξ, ζ, A, φ, p_re, p_im, q_re, q_im],
        [],
        [],
        (:bottom, c_ocn, z_bty, R_btm)
    )

    events = [
        maximum_range
        surface_reflection
        bottom_reflection
    ]

    ODESystem(eqns, s, deps, [];
        name = name,
        tspan = DEFAULT_RAY_ARC_SPAN,
        continuous_events = events,

    ) |> structural_simplify |> complete
end

struct Fan
    beams::Vector{Beam}
    sys::ODESystem
    prob::EnsembleProblem

    function Fan(model::Val, sys::ODESystem, ens_prob::EnsembleProblem, ens_sol::EnsembleSolution, f::Real, c::Function)
        beams = [Beam(model, sol, sys, f) for sol in ens_sol]
        new(beams, sys, ens_prob)
    end
end

function show(io::IO, fan::Fan)
    xtr = [beam.θ(0) for beam in fan.beams] |> extrema .|> rad2deg
    show(io, "Fan($(fan.beams |> length): $(xtr |> minimum)° .. $(xtr |> maximum)°)")
end

function Fan(
    model::Val,
    θ₀s::AbstractVector{<:Real},
    f::Real,
    z₀::Real,
    r_max::Real,
    c_ocn::Function,
    z_bty::Function,
    R_btm::Function,
    z_ati::Function,
    R_srf::Function
)
    @mtkbuild sys = TracingODESystem(c_ocn, r_max, z_bty, R_btm, z_ati, R_srf)
    r₀ = 0.0
    init = beam_initial_conditions(model, sys, f = f, r₀ = r₀, z₀ = z₀, c₀ = c_ocn(r₀, z₀), θ₀ = θ₀s[begin])
    prob = ODEProblem(sys, init, DEFAULT_RAY_ARC_SPAN)
    prob_func(prob_, i, _) = remake(
        prob_,
        u0 = beam_initial_conditions(model, sys, f = f, r₀ = r₀, z₀ = z₀, c₀ = c_ocn(r₀, z₀), θ₀ = θ₀s[i])
    )
    ens_prob = EnsembleProblem(prob, prob_func = prob_func)
    ens_sol = solve(ens_prob, Tsit5(), EnsembleThreads(), reltol = 1e-50, trajectories = length(θ₀s))

    return Fan(model, sys, ens_prob, ens_sol, f, c_ocn)
end

Fan(model::Val, θ₀::Real, args...) = Fan(model, [θ₀], args...)
Fan(model::Union{Symbol, <:AbstractString}, args...) = Fan(model |> modelval, args...)