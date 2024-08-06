export Surface
export Bottom

abstract type OceanInterface end
abstract type Surface <: OceanInterface end
abstract type Bottom <: OceanInterface end

struct BoundaryProfileFunctionType{BoundaryType <: OceanInterface} <: ModellingFunction{2} end
