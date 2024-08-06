export Atmosphere
export Ocean
export Seabed

abstract type AcousticMedium end

abstract type Atmosphere <: AcousticMedium end
abstract type Ocean <: AcousticMedium end
abstract type Seabed <: AcousticMedium end
