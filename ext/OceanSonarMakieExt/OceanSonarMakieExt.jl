module OceanSonarMakieExt

using OceanSonar
using Makie

import OceanSonar: visual!, visual, OceanAxis
import Makie: AbstractAxis, convert_arguments

function OceanAxis(pos::GridPosition)
    axis = Axis(pos[1, 1],
        yreversed = true,
        xlabel = "Range [m]",
        ylabel = "Depth [m]"
    )
    return axis
end

function visual(args...)
    fig = Figure()
    pos = fig[1, 1]
    OceanAxis(pos)
    visual!(pos, args...)
    return fig
end

include("boundary.jl")
include("bivariate.jl")
include("ray.jl")
include("propagation.jl")

end # module OceanSonarMakieExt