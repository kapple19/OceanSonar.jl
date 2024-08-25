export Seabed

"""
TODO.
"""
@kwdef mutable struct Seabed <: Medium
    model::Val = Val(Symbol())
    cel::SeabedCelerity = SeabedCelerity()
    den::SeabedDensity = SeabedDensity()
    atn::SeabedAttenuation = SeabedAttenuation()
    shear_cel::ShearSeabedCelerity = ShearSeabedCelerity()
    shear_atn::ShearSeabedAttenuation = ShearSeabedAttenuation()
end

function Seabed(model::Val)
    model |> modelsymbol ∉ list_model_symbols(Seabed) && error(
        "Invalid Seabed model. Try one of: ",
        list_models(Seabed)
    )
    Seabed(
        model = model,
        cel = SeabedCelerity(model),
        den = SeabedDensity(model),
        atn = SeabedAttenuation(model),
        shear_cel = ShearSeabedCelerity(model),
        shear_atn = ShearSeabedAttenuation(model)
    )
end

@parse_models Seabed

function list_model_symbols(::Type{Seabed})
    components = [SeabedCelerity, SeabedDensity, SeabedAttenuation, ShearSeabedCelerity, ShearSeabedAttenuation]
    list_model_symbols.(components) |> splat(intersect)
end