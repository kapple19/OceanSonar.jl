export atmosphere_celerity
export AtmosphereCelerity

@implement_3D_modelling atmosphere_celerity

atmosphere_celerity(::Val{:standard}, x::Real, y::Real, z::Real) = 343.0