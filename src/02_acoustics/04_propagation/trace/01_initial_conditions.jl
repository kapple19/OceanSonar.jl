function beam_initial_conditions(::Val{:gaussian}, sys::ODESystem;
    f, r₀, z₀, c₀, θ₀
)
    ω = 2π * f

    ξ₀, ζ₀ = ocnson_cossin(θ₀) ./ c₀
    λ₀ = c₀ / f
    W₀ = 30λ₀
    p₀ = 1.0 + 0.0im
    q₀ = 0.5im * ω * W₀^2

    return [
        sys.r => r₀
        sys.z => z₀
        sys.ξ => ξ₀
        sys.ζ => ζ₀
        sys.A => 1.0
        sys.φ => 0.0
        sys.τ => 0.0
        sys.p_re => real(p₀)
        sys.p_im => imag(p₀)
        sys.q_re => real(q₀)
        sys.q_im => imag(q₀)
    ]
end