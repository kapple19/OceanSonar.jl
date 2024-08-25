export OcnSon

export Univariate
export Bivariate
export Trivariate

abstract type OcnSon end
abstract type Functor <: OcnSon end
abstract type Univariate <: Functor end
abstract type Bivariate <: Functor end
abstract type Trivariate <: Functor end
abstract type Container <: OcnSon end
abstract type Result <: OcnSon end
abstract type Config <: OcnSon end

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