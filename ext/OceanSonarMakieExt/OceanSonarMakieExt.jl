module OceanSonarMakieExt

using OceanSonar
using Makie

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

include("boundary.jl")
include("celerity.jl")
include("ray.jl")
include("propagation.jl")

end