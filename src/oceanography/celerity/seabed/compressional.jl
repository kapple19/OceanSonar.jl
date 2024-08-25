export seabed_celerity
export SeabedCelerity

"""
TODO.
"""
function seabed_celerity end

seabed_celerity(::Val{:jensen_clay}, x::Real, z::Real) = 1500.0
seabed_celerity(::Val{:jensen_silt}, x::Real, z::Real) = 1575.0
seabed_celerity(::Val{:jensen_sand}, x::Real, z::Real) = 1650.0
seabed_celerity(::Val{:jensen_gravel}, x::Real, z::Real) = 1800.0
seabed_celerity(::Val{:jensen_moraine}, x::Real, z::Real) = 1950.0
seabed_celerity(::Val{:jensen_chalk}, x::Real, z::Real) = 2400.0
seabed_celerity(::Val{:jensen_limestone}, x::Real, z::Real) = 3000.0
seabed_celerity(::Val{:jensen_basalt}, x::Real, z::Real) = 5250.0

@parse_models_w_args seabed_celerity

"""
TODO.
"""
struct SeabedCelerity <: Celerity
    model::Val
end

(cel::SeabedCelerity)(x::Real, z::Real) = seabed_celerity(cel.model, x, z)

@parse_models SeabedCelerity

SeabedCelerity() = SeabedCelerity(Symbol())

list_model_symbols(::Type{SeabedCelerity}) = list_model_symbols(seabed_celerity)