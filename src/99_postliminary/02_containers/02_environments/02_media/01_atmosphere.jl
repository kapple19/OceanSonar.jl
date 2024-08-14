AcousticMedium{AtmosphereMedium}(::ModelName{:Calm}) = AcousticMedium{AtmosphereMedium}(
    cel = AtmosphereCelerityProfile(:Homogeneous),
    den = AtmosphereDensityProfile(:Homogeneous)
)
