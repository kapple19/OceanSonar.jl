export Beam

const RAY_ARC_LENGTH_SPAN = (0, EQUATORIAL_EARTH_CIRCUMFERENCE)
const PRESURE_MAGNITUDE_TERMINATION_VALUE = 1e-10

function AcousticTracingODESystem(
    model::Model,
    r_max::Real,
    f::Real,
    c_ocn::Function,
    z_bty::Function,
    R_btm::Function,
    z_ati::Function,
    R_srf::Function;
    name
) where {Model <: ModelName}
    @parameters begin
        s, [description = "Ray arc length"]
    end

    pars = @parameters begin
        θ₀
        r₀ = 0.0
        z₀
    end

    ξ₀, ζ₀, p₀, q₀ = beam_initial_conditions(model, f, θ₀, r₀, z₀, c_ocn(r₀, z₀))

    deps = @variables begin
        θ(s)::Real = θ₀
        c(s)::Real # = c_ocn(r₀, z₀)
        A(s)::Real = 1.0
        φ(s)::Real = 0
        τ(s)::Real = 0.0
		r(s)::Real = r₀
		z(s)::Real = z₀
		ξ(s)::Real = ξ₀
		ζ(s)::Real = ζ₀
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
        Ds(A) ~ 0
        Ds(φ) ~ 0
        Ds(τ) ~ 1 / c_ocn(r, z)
        Ds(r) ~ c_ocn(r, z) * ξ
        Ds(z) ~ c_ocn(r, z) * ζ
		Ds(ξ) ~ -∂c_∂r(r, z) / c_ocn(r, z)^2
		Ds(ζ) ~ -∂c_∂z(r, z) / c_ocn(r, z)^2
        Ds(p_re) ~ ∂²c_∂n²_(r, z, ξ, ζ) * q_re
        Ds(p_im) ~ ∂²c_∂n²_(r, z, ξ, ζ) * q_im
        Ds(q_re) ~ -c_ocn(r, z) * p_re
        Ds(q_im) ~ -c_ocn(r, z) * p_im
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

    # TODO: Implement as discrete event
    # pressure_vanish = [q ~ PRESSURE_TERMINATION_VALUE] => (
    #     (ntg, _, _, _) -> terminate!(ntg),
    #     [], [], []
    # )

    return ODESystem(eqns, s, deps, pars;
        name = name,
        continuous_events = [
            maximum_range
            surface_reflection
            bottom_reflection
        ]
    )
end

struct Beam{
    CelerityFunctionType <: Function,
    AngleFunctionType <: Function,
    RangeFunctionType <: Function,
    DepthFunctionType <: Function,
    PressureFunctionType <: Function
} <: ModellingComputation
    s_max::Float64

    c::CelerityFunctionType
    θ::AngleFunctionType
    r::RangeFunctionType
    z::DepthFunctionType
    p::PressureFunctionType

    # c::Function
    # θ::Function
    # r::Function
    # z::Function
    # ξ::Function
    # ζ::Function
    # A::Function
    # φ::Function
    # τ::Function
    # p::Function
    # q::Function

    sol::ODESolution

    function Beam(model::ModelName, sys::ODESystem, sol::ODESolution, f::Real)
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

        function pressure(s::ArcLengthType, n::NormalDisplacementType = 0.0) where {
            ArcLengthType <: Union{<:Real, <:AbstractVector{<:Real}},
            NormalDisplacementType <: Union{<:Real, <:AbstractMatrix{<:Real}}
        }
            beam_pressure(model, s, n;
                (
                    var => getproperty(beam, var)
                    for var in (:c, :f, :r, :A, :φ, :τ, :p, :q, :θ)
                )...
            )
        end

        fcns = (c, θ, r, z, pressure)

        new{typeof.(fcns)...}(sol.t[end], fcns..., sol)
    end
end

show(io::IO, ::MIME"text/plain", beam::Beam) = print(io, "Beam($(beam.θ(0) |> rad2deg)°)")

function (beam::Beam)(s::ArcLengthType, n::NormalDisplacementType) where {
    ArcLengthType <: Union{<:Real, <:AbstractVector{<:Real}},
    NormalDisplacementType <: Union{<:Real, <:AbstractMatrix{<:Real}}
}
    beam.p(s, n)
end
