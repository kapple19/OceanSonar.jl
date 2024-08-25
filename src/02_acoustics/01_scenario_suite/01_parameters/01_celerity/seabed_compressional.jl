export seabed_celerity
export SeabedCelerity

@implement_modelling seabed_celerity 3

seabed_celerity(::Val{:jensen_clay}, x::Real, y::Real, z::Real) = 1500.0
seabed_celerity(::Val{:jensen_silt}, x::Real, y::Real, z::Real) = 1575.0
seabed_celerity(::Val{:jensen_sand}, x::Real, y::Real, z::Real) = 1650.0
seabed_celerity(::Val{:jensen_gravel}, x::Real, y::Real, z::Real) = 1800.0
seabed_celerity(::Val{:jensen_moraine}, x::Real, y::Real, z::Real) = 1950.0
seabed_celerity(::Val{:jensen_chalk}, x::Real, y::Real, z::Real) = 2400.0
seabed_celerity(::Val{:jensen_limestone}, x::Real, y::Real, z::Real) = 3000.0
seabed_celerity(::Val{:jensen_basalt}, x::Real, y::Real, z::Real) = 5250.0
