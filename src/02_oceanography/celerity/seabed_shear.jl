export shear_seabed_celerity
export ShearSeabedCelerity

@implement_3D_modelling shear_seabed_celerity

shear_seabed_celerity(::Val{:jensen_clay}, x::Real, y::Real, z::Real) = 50.0
shear_seabed_celerity(::Val{:jensen_silt}, x::Real, y::Real, z::Real) = 80∛(z)
shear_seabed_celerity(::Val{:jensen_sand}, x::Real, y::Real, z::Real) = 110∛(z)
shear_seabed_celerity(::Val{:jensen_gravel}, x::Real, y::Real, z::Real) = 180∛(z)
shear_seabed_celerity(::Val{:jensen_moraine}, x::Real, y::Real, z::Real) = 600.0
shear_seabed_celerity(::Val{:jensen_chalk}, x::Real, y::Real, z::Real) = 1000.0
shear_seabed_celerity(::Val{:jensen_limestone}, x::Real, y::Real, z::Real) = 1500.0
shear_seabed_celerity(::Val{:jensen_basalt}, x::Real, y::Real, z::Real) = 2500.0
