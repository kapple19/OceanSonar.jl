export Trace
export Beam

struct Beam
    path::Function
    pressure::Function
end

(beam::Beam)(s::RealScalarOrArray) = beam.path(s)
(beam::Beam)(s::RealScalarOrArray, n::RealScalarOrArray) = beam.pressure(s, n)

@kwdef struct TraceConfiguration
    model::Model{M} where {M} = Model{:Gaussian}
end

struct Trace
    model::Model{M} where {M}

    function Trace(model; kw...)
        configuration = TraceConfiguration(; model = model, kw...)
        trace_beams()
    end
end

(trc::Trace)(θ₀s::RealScalarOrArray, φ₀s::RealScalarOrArray) = Beam.(θ₀s, φ₀s)
