export seabed_density
export SeabedDensity

"""
TODO.
"""
function seabed_density end

seabed_density(::Val{:jensen_clay}, x::Real, z::Real) = 1500.0
seabed_density(::Val{:jensen_silt}, x::Real, z::Real) = 1700.0
seabed_density(::Val{:jensen_sand}, x::Real, z::Real) = 1900.0
seabed_density(::Val{:jensen_gravel}, x::Real, z::Real) = 2000.0
seabed_density(::Val{:jensen_moraine}, x::Real, z::Real) = 2100.0
seabed_density(::Val{:jensen_chalk}, x::Real, z::Real) = 2200.0
seabed_density(::Val{:jensen_limestone}, x::Real, z::Real) = 2400.0
seabed_density(::Val{:jensen_basalt}, x::Real, z::Real) = 2700.0

@parse_models_w_args seabed_density

"""
TODO.
"""
struct SeabedDensity <: Density
    model::Val
end

(den::SeabedDensity)(x::Real, z::Real) = seabed_density(den.model, x, z)

@parse_models SeabedDensity

SeabedDensity() = SeabedDensity(Symbol())

list_model_symbols(::Type{SeabedDensity}) = list_model_symbols(seabed_density)