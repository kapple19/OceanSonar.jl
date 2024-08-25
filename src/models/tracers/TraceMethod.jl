@reexport module TraceMethod

using ...Structures
import ...Structures: Trace

using OrdinaryDiffEq: ODEProblem, solve, Tsit5, ContinuousCallback

function default_launch_angles(scn::Scenario)
    return atan(3/1) * range(-1, 1, 21)
end

function reflect!(int)
    ζ = int.u[4]
    int.u[4] = -ζ
end

function Trace(
    scn::Scenario;
    θ₀s::AbstractVector{<:Real} = default_launch_angles(scn),
    tracer::Tracer = Tracer("ray")
)
    trace! = tracer.def_trace(scn)
    u₀ = tracer.prep_init_conds(scn)
    update_init_conds! = tracer.def_update_init_conds(scn)
    span_s = (0.0, 10e3)

    function ati_cond(u, t, int)
        z = u[2]
    end

    ati_affect! = reflect!

    ati_cb = ContinuousCallback(ati_cond, ati_affect!)
    
    traces = tracer.TraceType[]
    for θ₀ in θ₀s
        update_init_conds!(u₀, θ₀)
        prob = ODEProblem(trace!, u₀, span_s)
        sol = solve(prob, Tsit5(), callback = ati_cb)
        push!(traces, tracer.TraceType(sol, scn))
    end

    return Trace(traces)
end # Trace

end