export Environment

mutable struct Environment <: ModellingContainer
    srf::AcousticInterface{SurfaceInterface}
    bot::AcousticInterface{BottomInterface}

    atm::AcousticMedium{AtmosphereMedium}
    ocn::AcousticMedium{OceanMedium}
    sbd::AcousticMedium{SeabedMedium}

    orienter::Function

    function Environment(;
        ocn::AcousticMedium{OceanMedium} = AcousticMedium{OceanMedium}(:Homogeneous),
        bot::AcousticInterface{BottomInterface} = AcousticInterface{BottomInterface}(:TranslucentDeep),
        atm::AcousticMedium{AtmosphereMedium} = AcousticMedium{AtmosphereMedium}(:Calm),
        srf::AcousticInterface{SurfaceInterface} = AcousticInterface{SurfaceInterface}(:Translucent),
        sbd::AcousticMedium{SeabedMedium} = AcousticMedium{SeabedMedium}(:Homogeneous),
        orienter::Function = (args...) -> orient(SpatialDimensionSize{3}, args...; x₀ = 0.0, y₀ = 0.0, θ = 0.0)
    )
        new(srf, bot, atm, ocn, sbd, orienter)
    end
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
