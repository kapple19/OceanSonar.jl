import OceanSonar: rayplot!, rayplot

@recipe(RayPlot) do scene
    Theme()
end

function ray_series_data(beam)
    arc = OceanSonar.default_arc_points(beam)
    return [
        Point2(beam.x(s), beam.z(s))
        for s in arc
    ]
end

function rayplot_!(plot::Plot, beams::Vector{Beam})
    rays = [ray_series_data(beam) for beam in beams]
    series!(plot,
        rays,
        solid_color = :black,
    )
    return plot
end

rayplot_!(::Plot, args...) = error(
    "No method matching desired signature for", args, ".\n",
    "Try one of these:\n",
    methods(rayplot_!)
)

function Makie.plot!(plot::RayPlot)
    get_plot_arguments(plot) |> splat(rayplot_!)
end

function visual!(beams::Vector{Beam}; kw...)
    rayplot!(beams; kw...)
    return current_figure()
end

visual!(beam::Beam; kw...) = visual!([beam]; kw...)