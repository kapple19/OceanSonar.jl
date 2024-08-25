export Atmosphere

"""
TODO.
"""
mutable struct Atmosphere <: Medium
    model::Val
    cel::AtmosphereCelerity
end

function Atmosphere(; kwargs...)
    length(kwargs) == 0 && return Atmosphere(:standard |> Val)
    atm = Atmosphere()
    for (key, val) in kwargs
        setfield!(atm, key, val)
    end
    return atm
end

Atmosphere(model::Val{:standard}) = Atmosphere(
    model,
    AtmosphereCelerity(:standard |> Val)
)

@parse_models Atmosphere