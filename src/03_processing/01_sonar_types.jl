export SonarType
export Passive
export Narrowband
export Broadband
export Intercept
export Active
export Monostatic
export Bistatic
export NoiseLimited
export ReverberationLimited

abstract type SonarType end

abstract type Passive <: SonarType end
abstract type Active <: SonarType end

abstract type Narrowband <: Passive end
abstract type Broadband <: Passive end
abstract type Intercept <: Passive end

abstract type Monostatic <: Active end
abstract type Bistatic <: Active end

abstract type NoiseLimited <: Monostatic end
abstract type ReverberationLimited <: Monostatic end
