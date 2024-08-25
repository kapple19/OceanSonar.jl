export Boundary

@kwdef mutable struct Boundary{T} <: OcnSonFun
    model::String = ""
end