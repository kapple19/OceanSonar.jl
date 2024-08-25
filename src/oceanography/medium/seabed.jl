export Seabed

"""
TODO.
"""
@kwdef mutable struct Seabed <: Medium
    model::Val = Val(Symbol())
    cel::Celerity = SeabedCelerity()
end

Seabed(model::Val{:jensen_gravel}) = Seabed(
    model = model,
    cel = SeabedCelerity(:jensen_gravel |> Val)
)

@parse_models Seabed