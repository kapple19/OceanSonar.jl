export seabed_density_profile

const seabed_density_profile = DensityProfileFunctionType{Seabed}()

seabed_density_profile(::ModelName{:Homogeneous}, x::Real, y::Real, z::Real; ρ::Real = 3000.0)::Real = ρ
