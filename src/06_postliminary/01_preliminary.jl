export Atmosphere
export Ocean
export Seabed

abstract type Medium end

abstract type Atmosphere <: Medium end
abstract type Ocean <: Medium end
abstract type Seabed <: Medium end
