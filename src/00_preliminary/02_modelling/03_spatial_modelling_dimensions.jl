struct SpatialDimensionSize{D} end

SpatialDimensionSize(::Type) = SpatialDimensionSize{0}
SpatialDimensionSize(FunctorType::Type{<:ModellingFunctor}) = SpatialDimensionSize(FunctorType |> ModellingFunction)
SpatialDimensionSize(modelling_instance::ModellingType) = SpatialDimensionSize(modelling_instance |> typeof)
