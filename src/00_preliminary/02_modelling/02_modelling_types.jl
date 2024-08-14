abstract type ModellingType <: Function end

abstract type ModellingFunction <: ModellingType end
abstract type ModellingFunctor <: ModellingType end
abstract type ModellingContainer <: ModellingType end
abstract type ModellingComputation <: ModellingType end

children(T::Type{<:ModellingType}) = subtypes(T)

abstract type EnvironmentComponent end

children(T::Type{<:EnvironmentComponent}) = subtypes(T)
