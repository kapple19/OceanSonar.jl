export Beam

const DEFAULT_RAY_ARC_LENGTH_SPAN = (0, EQUATORIAL_EARTH_CIRCUMFERENCE)

function AcousticTracingODESystem(
    r_max::Real,
    f::Real,
    c_ocn::Function;
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

    c₀ = c_ocn(r₀, z₀)
    ω = 2π * f
    λ₀ = c₀ / f
    W₀ = 30λ₀
    p₀ = 1.0 + 0.0im
    q₀ = 0.0 + 0.5im * ω * W₀^2

    deps = @variables begin
        θ(s)::Real = θ₀
        c(s)::Real
		r(s)::Real = r₀
		z(s)::Real = z₀
		ξ(s)::Real = cos(θ₀) / c_ocn(r₀, z₀)
		ζ(s)::Real = sin(θ₀) / c_ocn(r₀, z₀)
        A(s)::Real = 1.0
        φ(s)::Real = 0
        τ(s)::Real = 0.0
        p_re(s)::Real = real(p₀)
        p_im(s)::Real = imag(p₀)
        q_re(s)::Real = real(q₀)
        q_im(s)::Real = imag(q₀)
    end

    Ds = Differential(s)

    c²(r′, z′) = c_ocn(r′, z′)^2
    ∂c_∂r(r′, z′) = ModelingToolkit.derivative(c_ocn(r, z′), r′)
    ∂c_∂z(r′, z′) = ModelingToolkit.derivative(c_ocn(r′, z), z′)
    ∂²c_∂r²(r′, z′) = ModelingToolkit.derivative(∂c_∂r(r, z′), r′)
    ∂²c_∂z²(r′, z′) = ModelingToolkit.derivative(∂c_∂z(r′, z), z′)
    ∂²c_∂r∂z(r′, z′) = ModelingToolkit.derivative(∂c_∂z(r, z′), r′)
    ∂²c_∂n²_(r′, z′, ξ′, ζ′) = 2∂²c_∂r∂z(r′, z′) * ξ′ * ζ′ - ∂²c_∂r²(r′, z′) * ζ′^2 - ∂²c_∂z²(r′, z′) * ξ′^2

    eqns = [
        θ ~ atan(ζ, ξ)
        c ~ c_ocn(r, z)
        Ds(r) ~ c_ocn(r, z) * ξ
        Ds(z) ~ c_ocn(r, z) * ζ
		Ds(ξ) ~ -∂c_∂r(r, z) / c_ocn(r, z)^2
		Ds(ζ) ~ -∂c_∂z(r, z) / c_ocn(r, z)^2
        Ds(A) ~ 0
        Ds(φ) ~ 0
        Ds(τ) ~ 1 / c_ocn(r, z)
        Ds(p_re) ~ ∂²c_∂n²_(r, z, ξ, ζ) * q_re
        Ds(p_im) ~ ∂²c_∂n²_(r, z, ξ, ζ) * q_im
        Ds(q_re) ~ -c_ocn(r, z) * p_re
        Ds(q_im) ~ -c_ocn(r, z) * p_im
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

struct Beam <: ModellingComputation
    s_max::Float64

    c::Function
    θ::Function
    r::Function
    z::Function
    ξ::Function
    ζ::Function
    A::Function
    φ::Function
    τ::Function
    p::Function
    q::Function

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
        A(s::Real) = sol(s, idxs = sys.A)
        A(s::AbstractVector{<:Real}) = sol(s, idxs = sys.A) |> collect
        φ(s::Real) = sol(s, idxs = sys.φ)
        φ(s::AbstractVector{<:Real}) = sol(s, idxs = sys.φ) |> collect
        τ(s::Real) = sol(s, idxs = sys.τ)
        τ(s::AbstractVector{<:Real}) = sol(s, idxs = sys.τ) |> collect

        p(s::Real) = sol(s, idxs = sys.p_re) + im * sol(s, idxs = sys.p_im)
        p(s::AbstractVector{<:Real}) = sol(s, idxs = sys.p_re) + im * sol(s, idxs = sys.p_im) |> collect
        q(s::Real) = sol(s, idxs = sys.q_re) + im * sol(s, idxs = sys.q_im)
        q(s::AbstractVector{<:Real}) = sol(s, idxs = sys.q_re) + im * sol(s, idxs = sys.q_im) |> collect

        new(sol.t[end], c, θ, r, z, ξ, ζ, A, φ, τ, p, q, sol)
    end
end

show(io::IO, beam::Beam) = print(io, "Beam($(beam.θ(0) |> rad2deg)°)")
