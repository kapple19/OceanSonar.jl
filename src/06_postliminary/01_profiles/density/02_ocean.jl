export ocean_density_profile

const ocean_density_profile = DensityProfileFunctionType{Ocean}()

ocean_density_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 1029.0)::Real = ρ
