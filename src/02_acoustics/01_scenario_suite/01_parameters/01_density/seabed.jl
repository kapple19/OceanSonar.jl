export seabed_density
export SeabedDensity

@implement_modelling seabed_density 3

seabed_density(::Val{:jensen_clay}, x::Real, y::Real, z::Real) = 1500.0
seabed_density(::Val{:jensen_silt}, x::Real, y::Real, z::Real) = 1700.0
seabed_density(::Val{:jensen_sand}, x::Real, y::Real, z::Real) = 1900.0
seabed_density(::Val{:jensen_gravel}, x::Real, y::Real, z::Real) = 2000.0
seabed_density(::Val{:jensen_moraine}, x::Real, y::Real, z::Real) = 2100.0
seabed_density(::Val{:jensen_chalk}, x::Real, y::Real, z::Real) = 2200.0
seabed_density(::Val{:jensen_limestone}, x::Real, y::Real, z::Real) = 2400.0
seabed_density(::Val{:jensen_basalt}, x::Real, y::Real, z::Real) = 2700.0
