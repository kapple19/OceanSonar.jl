AcousticMedium{SeabedMedium}(::ModelName{:Homogeneous}) = AcousticMedium{SeabedMedium}(
    cel = SeabedCelerityProfile(:Homogeneous),
    den = SeabedDensityProfile(:Homogeneous)
)