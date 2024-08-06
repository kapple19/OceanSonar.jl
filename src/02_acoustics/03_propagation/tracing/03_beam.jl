export Beam

const DEFAULT_RAY_ARC_LENGTH_SPAN = (0, EQUATORIAL_EARTH_CIRCUMFERENCE)

function AcousticTracingODESystem(
    c_ocn::Function,
    r_max::Real;
    name
)
    @parameters begin
        s, [description = "Ray arc length"]
    end

    pars = @parameters begin
        r₀ = 0.0
        z₀
        θ₀
    end

    deps = @variables begin
		r(s) = r₀
		z(s) = z₀
		ξ(s) = cos(θ₀) / c_ocn(r₀, z₀)
		ζ(s) = sin(θ₀) / c_ocn(r₀, z₀)
        θ(s), [description = "Ray angle, positive downwards"]
        c(s), [description = "Ray celerity"]
    end

    Ds = Differential(s)

    c²(r′, z′) = c_ocn(r′, z′)^2
    ∂c_∂r(r′, z′) = ModelingToolkit.derivative(c_ocn(r, z′), r′)
    ∂c_∂z(r′, z′) = ModelingToolkit.derivative(c_ocn(r′, z), z′)

    eqns = [
        Ds(r) ~ c_ocn(r, z) * ξ
        Ds(z) ~ c_ocn(r, z) * ζ
		Ds(ξ) ~ -∂c_∂r(r, z) / c_ocn(r, z)^2
		Ds(ζ) ~ -∂c_∂z(r, z) / c_ocn(r, z)^2
        θ ~ atan(ζ, ξ)
        c ~ c_ocn(r, z)
    ]
    
    maximum_range = [r ~ r_max] => (
        (ntg, _, _, _) -> terminate!(ntg),
        [], [], []
    )

    events = [
        maximum_range
    ]

    return ODESystem(eqns, s, deps, pars;
        name = name,
        continuous_events = events
    )
end

struct Beam{MN <: ModelName}
    model::MN

    s_max::Float64

    c::Function
    θ::Function
    r::Function
    z::Function
    ξ::Function
    ζ::Function

    sol::ODESolution

    function Beam(model::ModelName, sys::ODESystem, sol::ODESolution)
        r(s::Real) = sol(s, idxs = sys.r)
        r(s::AbstractVector{<:Real}) = sol(s, idxs = sys.r) |> collect
        z(s::Real) = sol(s, idxs = sys.z)
        z(s::AbstractVector{<:Real}) = sol(s, idxs = sys.z) |> collect
        ξ(s::Real) = sol(s, idxs = sys.ξ)
        ξ(s::AbstractVector{<:Real}) = sol(s, idxs = sys.ξ) |> collect
        ζ(s::Real) = sol(s, idxs = sys.ζ)
        ζ(s::AbstractVector{<:Real}) = sol(s, idxs = sys.ζ) |> collect
        c(s::Real) = sol(s, idxs = sys.c)
        c(s::AbstractVector{<:Real}) = sol(s, idxs = sys.c) |> collect
        θ(s::Real) = sol(s, idxs = sys.θ)
        θ(s::AbstractVector{<:Real}) = sol(s, idxs = sys.θ) |> collect

        new{model |> typeof}(model, sol.t[end], c, θ, r, z, ξ, ζ, sol)
    end
end

show(io::IO, beam::Beam) = print(io, "Beam($(beam.θ(0) |> rad2deg)°)")
