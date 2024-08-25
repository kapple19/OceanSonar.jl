export rayplot!
export rayplot

"""
TODO.
"""
struct Beam <: OcnSonContainer
    s_max::Float64
    s_rfl::Vector{Float64}

    x::Function
    z::Function
    p::Function
end

function rayplot! end
function rayplot end