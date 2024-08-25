export Univariate
export Bivariate
export Trivariate

export SpectralContent
export BandSize
export WaveForm
export NB
export BB
export CW
export FM
export NBorCW
export BBorFM

export SonarType
export Passive
export Active
export Exposure
export Intercept
export Monostatic
export Bistatic

abstract type OcnSon end
abstract type Functor <: OcnSon end
abstract type Univariate <: Functor end
abstract type Bivariate <: Functor end
abstract type Trivariate <: Functor end
abstract type Container <: OcnSon end
abstract type Result <: OcnSon end
abstract type Config <: OcnSon end

abstract type SpectralContent end
abstract type BandSize <: SpectralContent end
abstract type NB <: BandSize end
abstract type BB <: BandSize end
abstract type WaveForm <: SpectralContent end
abstract type CW <: WaveForm end
abstract type FM <: WaveForm end

NBorCW = Union{NB, CW}
BBorFM = Union{BB, FM}

abstract type SonarType{SC <: SpectralContent} end
abstract type Passive{SC <: SpectralContent} <: SonarType{SC} end
abstract type Exposure{BS <: BandSize} <: Passive{BS} end
abstract type Intercept{WF <: WaveForm} <: Passive{WF} end
abstract type Active{WF <: WaveForm} <: SonarType{WF} end
abstract type Monostatic{WF <: WaveForm} <: Active{WF} end
abstract type Bistatic{WF <: WaveForm} <: Active{WF} end

@doc """
`OceanSonar.OcnSon`

Supertype for OceanSonar.jl containers and functors.
"""
OcnSon

@doc """
`OceanSonar.Functor`

Supertype for OceanSonar.jl functors.
"""
Functor

@doc """
`OceanSonar.Container`

Supertype for OceanSonar.jl containers for data.
"""
Container

@doc """
`OceanSonar.Result`

Supertype for OceanSonar.jl containers for results and data.
"""
Result

@doc """
`OceanSonar.Config`

Supertype for OceanSonar.jl configuration structures.
"""
Config