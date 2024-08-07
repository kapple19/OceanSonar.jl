export altimetry_profile
export AltimetryProfile

@implement_environment_function_and_functor Surface Boundary
const altimetry_profile = surface_boundary_profile
AltimetryProfile = SurfaceBoundaryProfile

surface_boundary_profile(::ModelName{:Flat}, x::Real, y::Real; z::Real = 0.0)::Float64 = z
