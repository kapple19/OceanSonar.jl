mutable struct Trace <: OcnSon
    rays::Vector{<:Ray}
    beams::Vector{<:Beam}

    Trace() = new()
end

function Trace(rays::AbstractVector{<:Ray})
    trc = Trace()
    trc.rays = rays
    return trc
end

function Trace(beams::AbstractVector{<:Beam})
    trc = Trace()
    trc.beams = beams
    return trc
end