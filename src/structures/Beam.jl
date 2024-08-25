"""
```
Beam
```
"""
struct Beam <: OcnSon
    ray::Ray
    p
end

function Beam(sol::AbstractODESolution, scn::Scenario)
    ray = Ray(sol)

    δθ₀ = 1.0

    ω = 2π * scn.src.f
    x = ray.x
    z = ray.z
    τ = ray.τ
    θ = ray.θ
    c(s) = scn.env.ocn.cel(x(s), z(s))
    p(s) = sol(s, idxs = 6) + im * sol(s, idxs = 7)
    q(s) = sol(s, idxs = 8) + im * sol(s, idxs = 9)
    A = δθ₀ / c(0) * exp(im * π / 4) * sqrt(
        q(0) * ω * cos(θ(0)) / 2π
    )

    function pressure(s, n)
        A * sqrt(c(s) / x(s) / q(s)) * exp(
            -im * ω * (
                τ(s) + p(s) / q(s) * n^2 / 2
            )
        )
    end

    Beam(ray, pressure)
end