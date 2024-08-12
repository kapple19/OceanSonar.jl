export altimetry_profile
export AltimetryProfile

@implement_spatially_modelled_function_and_functor AltimetryProfile 2

altimetry_profile(::ModelName{:Flat}, x::Real, y::Real; z::Real = 0.0) = z
