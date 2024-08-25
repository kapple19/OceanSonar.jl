export Atmosphere

"""
TODO.
"""
mutable struct Atmosphere <: Medium
    model::Val
    cel::AtmosphereCelerity
    den::AtmosphereDensity
    atn::AtmosphereAttenuation
end

function Atmosphere(; kwargs...)
    length(kwargs) == 0 && return Atmosphere(:standard)
    atm = Atmosphere()
    for (key, val) in kwargs
        setfield!(atm, key, val)
    end
    return atm
end

Atmosphere(model::Val{:standard}) = Atmosphere(
    model,
    AtmosphereCelerity(:standard),
    AtmosphereDensity(:standard),
    AtmosphereAttenuation(:standard)
)

@parse_models Atmosphere