export seabed_celerity
export SeabedCelerity

"""
TODO.
"""
function seabed_celerity end

seabed_celerity(::Val{:jensen_gravel}, x::Real, z::Real) = 1800.0

@parse_models_and_arguments seabed_celerity

"""
TODO.
"""
struct SeabedCelerity <: Celerity
    model::Val
end

(cel::SeabedCelerity)(x::Real, z::Real) = seabed_celerity(cel.model, x, z)

SeabedCelerity() = SeabedCelerity(Symbol() |> Val)

list_models(::Type{SeabedCelerity}) = list_models(seabed_celerity)