export Medium

@kwdef mutable struct Medium{T} <: OcnSon
    cel::Celerity = Celerity{T}()
    model::String = ""
end