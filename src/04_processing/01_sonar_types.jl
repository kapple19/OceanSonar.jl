export SonarType
export BandType
export BandType
export BandType
export Passive
export Exposure
export Intercept
export Active
export Monostatic
export Bistatic
export NB
export BB

abstract type BandType end
abstract type NB <: BandType end
abstract type BB <: BandType end

abstract type SonarType{BS <: BandType} end
abstract type Passive{BS <: BandType} <: SonarType{BS} end
abstract type Exposure{BS <: BandType} <: Passive{BS} end
abstract type Intercept{BS <: BandType} <: Passive{BS} end
abstract type Active{BS <: BandType} <: SonarType{BS} end
abstract type Monostatic{BS <: BandType} <: Active{BS} end
abstract type Bistatic{BS <: BandType} <: Active{BS} end
