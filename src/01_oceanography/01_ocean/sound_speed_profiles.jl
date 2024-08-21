export sound_speed_profile

## Implementation
@implement_metric_function sound_speed_profile

@doc """
```
sound_speed_profile(model::M, r::Real, z::Real) where {M <: Union{Symbol, <:AbstractString, <:Model}}
```

Speed [m/s] of sound in the ocean as a profile function
in terms of range `r` [m] and depth `z` [m].

Subtypes [`OceanSonar.MetricFunction`](@ref).
"""
sound_speed_profile

## Visualisation
"""
```
soundspeedlines2d
soundspeedlines2d!
```

Plotting functions. Methods to be populated by `Makie` extension.
"""
function soundspeedlines2d end

@doc (@doc soundspeedlines2d)
function soundspeedlines2d! end

## Models
"""
```
sound_speed_profile(::Model{:Homogeneous}; c::Real = 1500.0) = c
```

Homogeneous (constant) sound speed throughout the water column.
Defaults to 1500 m/s.
"""
sound_speed_profile(::Model{:Homogeneous}; c::Real = 1500.0) = c

"""
```
sound_speed_profile(::Model{:}, z::Real; ϵ = 7.37e-3)
```

Idealised ocean sound speed profile named after Walter Munk.

Equation 5.83 of Jensen, et al, 2011.
"""
function sound_speed_profile(::Model{:Munk}, z::Real; ϵ::Real = 7.37e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

"""
```
sound_speed_profile(::Model{:RefractionSquared}, z::Real; c₀::Real = 1550.0)
```

Equation 3.77 of Jensen, et al. (2011).
"""
function sound_speed_profile(::Model{:RefractionSquared}, z::Real; c₀::Real = 1550.0)
    return c₀ / Flex.sqrt(1 + 2.4z / c₀)
end

"`_sound_speed_profile_north_atlantic_linearised_itp` Internal interpolation object."
const _sound_speed_profile_north_atlantic_linearised_itp = LinearInterpolation(
    [NaN, 1522.0, 1502, 1514, 1496, 1545, NaN],
    [-Inf, 0.0, 300, 1200, 2e3, 5e3, Inf]
)

"""
```
sound_speed_profile(::Model{:NorthAtlanticLinearised}, z::Real)
```

Linearised form of a typical North Atlantic ocean sound speed profile.

Table 1.1 of Jensen, et al. (2011).
"""
function sound_speed_profile(::Model{:NorthAtlanticLinearised}, z::Real)
    return _sound_speed_profile_north_atlantic_linearised_itp(z)
end

"`_sound_speed_profile_mediterranean_sea_linearised_itp` Internal interpolation object."
const _sound_speed_profile_mediterranean_sea_linearised_itp = LinearInterpolation(
    [NaN, 1540.0, 1510, 1550, NaN],
    [-Inf, 0.0, 100, 2500, Inf]
)

"""
```
sound_speed_profile(::Model{:MediterraneanSeaLinearised}, z::Real)
```

Linearised form of a typical Mediterranean Sea ocean sound speed profile.

Table 1.2 of Jensen, et al. (2011).
"""
function sound_speed_profile(::Model{:MediterraneanSeaLinearised}, z::Real)
    return _sound_speed_profile_mediterranean_sea_linearised_itp(z)
end
