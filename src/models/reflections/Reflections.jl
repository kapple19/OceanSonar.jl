module Reflections

"""
```
reflection_coefficient("rayleigh", c₁::Real, c₂::Real, ρ₁::Real, ρ₂::Real, θ₁::Real)
```
"""
function rayleigh_fluid(
    c₁::Real, c₂::Real,
    ρ₁::Real, ρ₂::Real,
    α₁::Real, α₂::Real,
    θ₁::Real)

    δ₁ = α₁ * log(10) / 40π
    δ₂ = α₂ * log(10) / 40π

    ς₁ = c₁ * (1 - im * δ₁)
    ς₂ = c₂ * (1 - im * δ₂)

    θ₂ = acos(ς₂ / ς₁ * cos(θ₁))

    a₁ = ρ₁ * c₁
    a₂ = ρ₂ * c₂
    
    A₁ = a₁ * sin(θ₁)
    A₂ = a₂ * sin(θ₂)

    R = (A₁ - A₂) / (A₁ + A₂)
end

"""
```
rayleigh_solid
```
"""
function rayleigh_solid(
    c₁::Real, c₂::Real, c₂_shear::Real,
    ρ₁::Real, ρ₂::Real,
    α₁::Real, α₂::Real, α₂_shear::Real,
    θ₁::Real)

    δ₁ = α₁ * log(10) / 40π
    δ₂ = α₂ * log(10) / 40π
    δ₂_shear = α₂_shear * log(10) / 40π

    ς₁ = c₁ * (1 - im * δ₁)
    ς₂ = c₂ * (1 - im * δ₂)
    ς₂_shear = c₂_shear * (1 - im * δ₂_shear)

    z₁ = ρ₁ * ς₁
    z₂ = ρ₂ * ς₂
    z₂_shear = ρ₂ * ς₂_shear

    θ₂ = acos(ς₂ / ς₁ * cos(θ₁))
    θ₂_shear = acos(ς₂_shear / ς₁ * cos(θ₁))

    Z₂ = z₂ / sin(θ₂)
    Z₂_shear = z₂_shear / sin(θ₂_shear)

    Z_sbd = Z₂ * cos(2θ₂_shear)^2 + Z₂_shear * sin(2θ₂_shear)^2
    Z₁ = z₁ / sin(θ₁)

    R = (Z_sbd - Z₁) / (Z_sbd + Z₁)
end

end