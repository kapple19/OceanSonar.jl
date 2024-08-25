export boundaryplot!
export boundaryplot

abstract type Boundary <: OcnSonFunctor end

include("altimetry.jl")
include("bathymetry.jl")

function boundaryplot! end
function boundaryplot end