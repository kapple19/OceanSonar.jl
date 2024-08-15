export Environment

@kwdef mutable struct Environment <: ModellingContainer
    atm::AcousticMedium{AtmosphereMedium} = AcousticMedium{AtmosphereMedium}(:Calm)
    ocn::AcousticMedium{OceanMedium} = AcousticMedium{OceanMedium}(:Homogeneous)
    sbd::AcousticMedium{SeabedMedium} = AcousticMedium{SeabedMedium}(:Homogeneous)
    
    srf::AcousticInterface{SurfaceInterface} = AcousticInterface{SurfaceInterface}(:Translucent)
    bot::AcousticInterface{BottomInterface} = AcousticInterface{BottomInterface}(:TranslucentDeep)
    
    orienter::Function = (args...) -> orient(SpatialDimensionSize{3}, args...; x₀ = 0.0, y₀ = 0.0, θ = 0.0)

    NL::Float32 = 0.0
end

## Models
Environment(::ModelName{:SphericalSpreading}) = Environment(
    ocn = AcousticMedium{OceanMedium}(:Homogeneous),
    bot = AcousticInterface{BottomInterface}(:AbsorbentDeep),
    srf = AcousticInterface{BottomInterface}(:Absorbent)
)

Environment(::ModelName{:CylindricalSpreading}) = Environment(
    ocn = AcousticMedium{OceanMedium}(:Homogeneous),
    bot = AcousticInterface{BottomInterface}(:ReflectiveDeep),
    srf = AcousticInterface{BottomInterface}(:Reflective)
)

Environment(::ModelName{:SurfaceLloydMirror}) = Environment(
    ocn = AcousticMedium{OceanMedium}(:Homogeneous),
    bot = AcousticInterface{BottomInterface}(:AbsorbentDeep),
    srf = AcousticInterface{BottomInterface}(:Reflective)
)

Environment(::ModelName{:BottomLloydMirror}) = Environment(
    ocn = AcousticMedium{OceanMedium}(:Homogeneous),
    bot = AcousticInterface{BottomInterface}(:AbsorbentDeep),
    srf = AcousticInterface{BottomInterface}(:Reflective)
)

Environment(::ModelName{:MunkCelerity}) = Environment(
    ocn = AcousticMedium{OceanMedium}(:MunkCelerity),
    bot = AcousticInterface{BottomInterface}(:ReflectiveDeep)
)

Environment(::ModelName{:ParabolicBathymetry}) = Environment(
    ocn = AcousticMedium{OceanMedium}(:Homogeneous),
    bot = AcousticInterface{BottomInterface}(:ParabolicBathymetry)
)

Environment(::ModelName{:SquaredRefractionCelerity}) = Environment(
    ocn = AcousticMedium{OceanMedium}(:SquaredRefractionCelerity),
    bot = AcousticInterface{BottomInterface}(:AbsorbentMesopelagic)
)
