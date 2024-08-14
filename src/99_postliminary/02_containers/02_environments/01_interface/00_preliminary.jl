export Surface
export Bottom

abstract type InterfaceType <: EnvironmentComponent end

struct SurfaceInterface <: InterfaceType end
struct BottomInterface <: InterfaceType end

@kwdef mutable struct AcousticInterface{IT <: InterfaceType} <: ModellingContainer
    dpt::Function
    rfl::Function
end

Surface = AcousticInterface{SurfaceInterface}
Bottom = AcousticInterface{BottomInterface}
