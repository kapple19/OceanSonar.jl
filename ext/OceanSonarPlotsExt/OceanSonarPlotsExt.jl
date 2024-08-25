module OceanSonarPlotsExt

using OceanSonar
using Plots

import OceanSonar: visual!, visual

function visual(args...; kw...)
    plot()
    visual!(args...; kw...)
end

colourmap(::Any) = :jet

include("boundary.jl")
include("bivariate.jl")
include("medium.jl")
include("environment.jl")
include("scenario.jl")
include("beam.jl")
include("propagation.jl")

end