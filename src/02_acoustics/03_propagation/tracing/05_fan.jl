export Fan

struct Fan <: ModellingComputation
    beams::Vector{Beam}
    sys::ODESystem
    prob::EnsembleProblem

    function Fan(
        model::ModelName,
        θ₀s::AbstractVector{<:Real},
        z₀::Real,
        r_max::Real,
        f::Real,
        c_ocn::Function,
        z_bty::Function,
        R_btm::Function,
        z_ati::Function,
        R_srf::Function
    )
    @mtkbuild sys = AcousticTracingODESystem(model, r_max, f, c_ocn, z_bty, R_btm, z_ati, R_srf)
    prob = ODEProblem(sys, [], RAY_ARC_LENGTH_SPAN, [sys.θ₀ => 0.0, sys.z₀ => z₀])

    ### Begin: Ensembling
    # Attempt 1: Errors on `init`.
    # tiltray! = setp(sys, sys.θ₀)
    # prob_func(internal_prob, n, _) = tiltray!(internal_prob, θ₀s[n])

    # Attempt 2: Doesn't change launch angle parameter
    # function prob_func(internal_prob, n, _)
    #     new_prob = remake(internal_prob, p = [sys.θ₀ => θ₀s[n], sys.z₀ => z₀])
    #     @show prob.p[1]
    #     return new_prob
    # end

    # Attempt 3: Make an entirely new ODEProblem
    prob_func(_, n, _) = ODEProblem(sys, [], RAY_ARC_LENGTH_SPAN, [sys.θ₀ => θ₀s[n], sys.z₀ => z₀])
    ### End: Ensembling

    ens_prob = EnsembleProblem(prob, prob_func = prob_func)
    ens_sol = solve(ens_prob, Tsit5(), EnsembleThreads(),
        reltol = 1e-50,
        trajectories = length(θ₀s)
    )
        beams = [Beam(model, sys, sol, f) for sol in ens_sol]
        new(beams, sys, ens_prob)
    end
end

function show(io::IO, ::MIME"text/plain", fan::Fan)
    xtr = [beam.θ(0) for beam in fan.beams] |> extrema .|> rad2deg
    print(io, "Fan($(fan.beams |> length) beams: $(xtr |> minimum)° .. $(xtr |> maximum)°)")
end
