AcousticMedium{OceanMedium}(::ModelName{:Homogeneous}) = AcousticMedium{OceanMedium}(
    cel = OceanCelerityProfile(:Homogeneous),
    den = OceanCelerityProfile(:Homogeneous),
)

AcousticMedium{OceanMedium}(::ModelName{:MunkCelerity}) = AcousticMedium{OceanMedium}(
    cel = OceanCelerityProfile(:Munk),
)

AcousticMedium{OceanMedium}(::ModelName{:SquaredRefractionProfile}) = AcousticMedium{OceanMedium}(
    cel = OceanCelerityProfile(:SquaredRefraction)
)
