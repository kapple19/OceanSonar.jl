export Environment

@kwdef mutable struct Environment <: ModelContainer
    srf::Interface = Surface(:MirroredFlat)
    bot::Interface = Bottom(:TranslucentDeep)

    atm::Medium = Atmosphere(:Homogeneous)
    ocn::Medium = Ocean(:Homogeneous)
    sbd::Medium = Seabed(:Homogeneous)
end

Environment(::Model{:SphericalSpreading}) = Environment(
    srf = Surface(:AbsorbentFlat),
    bot = Bottom(:AbsorbentDeep),
)

Environment(::Model{:SurfaceLloydMirror}) = Environment(
    srf = Surface(:MirroredFlat),
    bot = Bottom(:AbsorbentDeep),
)

Environment(::Model{:BottomLloydMirror}) = Environment(
    srf = Surface(:AbsorbentFlat),
    bot = Bottom(:ReflectiveDeep),
)

Environment(::Model{:CylindricalSpreading}) = Environment(
    srf = Surface(:MirroredFlat),
    bot = Bottom(:ReflectiveDeep),
)

Environment(::Model{:ParabolicBathymetry}) = Environment(
    srf = Surface(:AbsorbentFlat),
    bot = Bottom(:ParabolicBathymetry),
)

Environment(::Model{:MunkSoundSpeed}) = Environment(
    srf = Surface(:AbsorbentFlat),
    bot = Bottom(:AbsorbentDeep),
    ocn = Environment(:MunkSoundSpeed),
)

Environment(::Model{:SquaredSoundSpeed}) = Environment(
    srf = Surface(:AbsorbentFlat),
    bot = Bottom(:),
    ocn = Environment(:SquaredSoundSpeed),
)
