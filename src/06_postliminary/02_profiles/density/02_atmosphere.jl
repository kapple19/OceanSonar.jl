export atmosphere_density_profile

## Instantiation
const atmosphere_density_profile = DensityProfileFunctionType{Atmosphere}()

## Models
atmosphere_density_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 1.225)::Real = ρ
