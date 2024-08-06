export altimetry_profile

const altimetry_profile = BoundaryProfileFunctionType{Surface}()

altimetry_profile(::ModelName{:Flat}, x::Real, y::Real; z::Real = 0.0)::Float64 = z
