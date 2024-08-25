module OceanSonarMakieExt

using OceanSonar
using Makie
using Makie: AbstractAxis

import OceanSonar: visual!, visual
import Makie: convert_arguments

function get_plot_arguments(plot::Plot)
    N = 0
    while true
        try
            N += 1
            plot[N].val
        catch
            N -= 1
            break
        end
    end
    idxs = 1:N
    return plot, (plot[n].val for n in idxs)...
end

function visual(args...; kw...)
    fig = Figure()
    Axis(fig[1, 1])
    visual!(args...; kw...)
    return fig
end

include("boundary_.jl")
include("bivariate_.jl")
include("medium_.jl")
include("environment_.jl")
include("scenario_.jl")
include("ray_.jl")
include("propagation_.jl")

end