## Models
### Generic Lossless Pressure Field
function pressure_field(
    ::Model{:DirectLossless},
    s::Real,
    λ::Real, c::Real = 1500, t::Real = 0
)
    @assert s >= 0
    return cispi(2(s - c*t)/λ)
end

### Spreading Loss
function pressure_field(
    ::Model{:SphericalSpreading},
    s::Real,
    λ::Real, c::Real = 1500, t::Real = 0
)
    return pressure_field(:DirectLossless, s, λ, c, t) / s
end

function pressure_field(
    ::Model{:CylindricalSpreading},
    s::Real,
    λ::Real, c::Real = 1500, t::Real = 0
)
    return pressure_field(:DirectLossless, s, λ, c, t) / sqrt(s)
end

function pressure_field(
    spreading_model::Union{Model{:SphericalSpreading}, Model{:CylindricalSpreading}},
    r::Real, z::Real,
    λ::Real, c::Real = 1500, t::Real = 0,
    z₀::Real = 0
)
    @assert r >= 0
    return pressure_field(spreading_model, hypot(r, z - z₀), λ, c, t)
end

### Single Reflections
function pressure_field(
    ::Model{:SurfaceReflection},
    r::Real, z::Real, z₀::Real,
    λ::Real, c::Real = 1500, t::Real = 0
)
    @assert r >= 0
    return -pressure_field(:SphericalSpreading, hypot(r, z + z₀), λ, c, t)
end

function pressure_field(
    ::Model{:BottomReflection},
    r::Real, z::Real, z₀::Real, z_bot::Real,
    λ::Real, c::Real = 1500, t::Real = 0
)
    @assert r >= 0
    return pressure_field(:SphericalSpreading, hypot(r, 2z_bot - z - z₀), λ, c, t)
end

### Lloyd Mirrors
function pressure_field(
    ::Model{:SurfaceLloydMirror},
    r::Real, z::Real, z₀::Real,
    λ::Real, c::Real = 1500, t::Real = 0
)
    return pressure_field(:SphericalSpreading, r, z, λ, c, t, z₀) + pressure_field(:SurfaceReflection, r, z, z₀, λ, c, t)
end

function pressure_field(
    ::Model{:BottomLloydMirror},
    r::Real, z::Real, z₀::Real, z_bot::Real,
    λ::Real, c::Real = 1500, t::Real = 0
)
    return pressure_field(:SphericalSpreading, r, z, λ, c, t, z₀) + pressure_field(:BottomReflection, r, z, z₀, z_bot, λ, c, t)
end

function pressure_field(
    ::Model{:SingleReflectionLloydMirror},
    r::Real, z::Real, z₀::Real, z_bot::Real,
    λ::Real, c::Real = 1500, t::Real = 0
)
    return pressure_field(:SphericalSpreading, r, z, λ, c, t, z₀) + pressure_field(:SurfaceReflection, r, z, z₀, λ, c, t) + pressure_field(:BottomReflection, r, z, z₀, z_bot, λ, c, t)
end

function pressure_field(
    ::Model{:FlatMultipath},
    r::Real, z::Real, z₀::Real, z_bot::Real,
    λ::Real, c::Real = 1500, t::Real = 0
)
    for n in 1:5
        d = floor((n - 1) / 2)
        d += mod(n, 0) ? 2z_bot - z : z

        for m in [-1, 1]
            d += m * z₀

            s = hypot(d, r)
        end
    end
end
