function TracingODESystem(
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

    @variables begin
        θ(s), [description = "Ray angle, positive downwards"]
        c(s), [description = "Ray celerity"]
    end

    deps = @variables begin
		r(s) = r₀
		z(s) = z₀
		ξ(s) = cos(θ₀) / c_ocn(r₀, z₀)
		ζ(s) = sin(θ₀) / c_ocn(r₀, z₀)
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
