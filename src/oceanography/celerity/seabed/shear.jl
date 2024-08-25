export shear_seabed_celerity
export ShearSeabedCelerity



"""
TODO.
"""
function shear_seabed_celerity end

shear_seabed_celerity(::Val{:jensen_clay}, x::Real, z::Real) = 50.0
shear_seabed_celerity(::Val{:jensen_silt}, x::Real, z::Real) = 80∛(z)
shear_seabed_celerity(::Val{:jensen_sand}, x::Real, z::Real) = 110∛(z)
shear_seabed_celerity(::Val{:jensen_gravel}, x::Real, z::Real) = 180∛(z)
shear_seabed_celerity(::Val{:jensen_moraine}, x::Real, z::Real) = 600.0
shear_seabed_celerity(::Val{:jensen_chalk}, x::Real, z::Real) = 1000.0
shear_seabed_celerity(::Val{:jensen_limestone}, x::Real, z::Real) = 1500.0
shear_seabed_celerity(::Val{:jensen_basalt}, x::Real, z::Real) = 2500.0

@parse_models_w_args shear_seabed_celerity

"""
TODO.
"""
struct ShearSeabedCelerity <: Celerity
    model::Val
end

function (shear_atn::ShearSeabedCelerity)(x::Real, z::Real)
    shear_seabed_celerity(shear_atn.model, x, z)
end

@parse_models ShearSeabedCelerity

ShearSeabedCelerity() = ShearSeabedCelerity(Symbol())

list_model_symbols(::Type{ShearSeabedCelerity}) = list_model_symbols(shear_seabed_celerity)