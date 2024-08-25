"""
```
struct Ray <: OcnSon
```
"""
struct Ray <: OcnSon
    s_imp::Vector{<:Float64}
    x::Function
    z::Function
    ξ::Function
    ζ::Function
    τ::Function
    θ::Function

    function Ray(
        s_imp::AbstractVector{<:Real},
        x::Function,
        z::Function,
        ξ::Function,
        ζ::Function,
        τ::Function,
        θ::Function
    )
        # Task: Update `s_imp` with critical points.
        new(s_imp, x, z, ξ, ζ, τ, θ)
    end
end

function Ray(sol::AbstractODESolution)
    s_imp = sol.t

    x(s) = sol(s, idxs = 1)
    z(s) = sol(s, idxs = 2)
    ξ(s) = sol(s, idxs = 3)
    ζ(s) = sol(s, idxs = 4)
    τ(s) = sol(s, idxs = 5)

    θ(s) = atan(ζ(s) / ξ(s))

    Ray(s_imp, x, z, ξ, ζ, τ, θ)
end

Ray(sol::AbstractODESolution, ::Scenario) = Ray(sol)