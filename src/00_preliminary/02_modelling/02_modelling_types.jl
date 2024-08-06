abstract type AbstractModeller <: Function end

abstract type ModellingFunction <: AbstractModeller end
abstract type ModellingFunctor <: AbstractModeller end

abstract type SpatialModellingFunction{D} <: AbstractModeller end
abstract type SpatialModellingFunctor{D} <: AbstractModeller end
