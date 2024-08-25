export atmosphere_celerity
export AtmosphereCelerity

@implement_modelling atmosphere_celerity 3

atmosphere_celerity(::Val{:standard}, x::Real, y::Real, z::Real) = 343.0