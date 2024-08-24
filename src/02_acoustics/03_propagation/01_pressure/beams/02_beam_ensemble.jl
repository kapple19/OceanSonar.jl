export beam_ensemble

function beam_ensemble(
    cel::Function,
    src_pos::@NamedTuple{x₀::AbscissaType, y₀::OrdinateType, z₀::DepthType},
    angles::AbstractVector{<:@NamedTuple{θ₀::AzimuthType, φ₀::DeclinationType}}
) where {
    AbscissaType <: Real,
    OrdinateType <: Real,
    DepthType <: Real,
    AzimuthType <: Real,
    DeclinationType <: Real
}
    cel_grad(pos) = ForwardDiff.gradient(pos -> cel(pos...), pos)

    function trace!(du, u, _, _)
        pos = @view u[1:3]
        tng = @view u[4:6]

        c = cel(pos...)
        ∇c = cel_grad(pos)
        du .= [
            c * tng ...
            -∇c / c^2 ...
        ]
    end

    tng_inits = [
        [
            cos(φ₀) .* [cos(θ₀), sin(θ₀)]...; sin(φ₀)
        ] for (; θ₀, φ₀) in angles
    ] / cel(src_pos...)

    function launch_ray(prob, n, _)
        prob.u0[4:6] .= tng_inits[n]
        return prob
    end

    function beam_output(sol, _)
        x(s) = sol(s, idxs = 1)
        y(s) = sol(s, idxs = 2)
        z(s) = sol(s, idxs = 3)

        return Beam(sol.t[end], x, y, z), false
    end

    prob = ODEProblem(trace!, [src_pos...; tng_inits[begin]...], (0, 200e3))
    ens_prob = EnsembleProblem(prob, prob_func = launch_ray, output_func = beam_output)
    ens_sol = solve(ens_prob, Tsit5(), EnsembleThreads(), reltol = 1e-50, trajectories = length(angles))
    return ens_sol.u
    
    # sol = solve(prob, Tsit5(), reltol = 1e-50)
    # return [beam_output(sol, nothing)]
end
