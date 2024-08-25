export visual!
export visual

function visual! end
function visual end

colour(modelling_instance::Union{<:ModellingFunction, <:ModellingFunctor}) = modelling_instance |> typeof |> colour

colour(::Type{Altimetry}) = :slateblue1
colour(::Type{Bathymetry}) = :sienna

colour(::Type{<:ModellingFunctor{3}}) = :jet
colour(::Type{OceanCelerity}) = :Blues

label(modelling_functor::ModellingFunctor) = modelling_functor |> typeof |> String |> titlecase