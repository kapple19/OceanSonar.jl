abstract type AbstractModeller <: Function end

abstract type ModellingFunction{D} <: AbstractModeller end
abstract type ModellingFunctor{D} <: AbstractModeller end