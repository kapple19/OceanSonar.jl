import OceanSonar: rayplot!, rayplot

@recipe(RayPlot) do scene
    Theme()
end

function rayplot_!(plot::Plot, beam::OceanSonar.Beam)
    s = [range(0, beam.s_max, 301); beam.s_rfl] |> OceanSonar.uniquesort!
    x = beam.x.(s)
    z = beam.z.(s)
    lines!(plot,
        x, z,
        color = :black,
        axis = (yreversed = true,)
    )
    return plot
end

function rayplot_!(plot::Plot, beams::Vector{<:OceanSonar.Beam})
    rayplot_!.(plot, beams)
end

function rayplot_!(plot::Plot, prop::OceanSonar.Trace)
    celerityplot!(prop.scen)
    rayplot_!(plot, prop.beams)
end

function Makie.plot!(plot::RayPlot)
    get_plot_arguments(plot) |> splat(rayplot_!)
end