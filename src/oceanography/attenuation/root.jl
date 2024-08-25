export attenuationplot!
export attenuationplot

abstract type Attenuation <: Trivariate end

include("atmosphere.jl")
include("ocean.jl")
include("seabed/root.jl")

function attenuationplot! end
function attenuationplot end