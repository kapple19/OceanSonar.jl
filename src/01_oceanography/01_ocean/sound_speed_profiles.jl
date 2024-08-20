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

Idealised ocean sound speed profile named after Walter Munk (Eqn 5.83 of Jensen, et al, 2011).
"""
function sound_speed_profile(::Model{:Munk}, z::Real; ϵ::Real = 7.37e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end
