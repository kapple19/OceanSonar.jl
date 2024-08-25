import OceanSonar: boundaryplot!, boundaryplot

@recipe(BoundaryPlot) do scene
    Theme()
end

function boundaryplot_!(
    plot::Plot,
    bnd::Altimetry,
    x_lo::Real,
    x_hi::Real
)
    x = range(x_lo, x_hi, 301)
    z_lo, _ = OceanSonar.depth_extrema(bnd, x_lo, x_hi)
    z_lower = z_lo
    z_upper = bnd.(x)
    band!(plot,
        x, z_lower, z_upper,
        color = :blue,
        axis = (yreversed = true,)
    )
    return plot
end

function boundaryplot_!(
    plot::Plot,
    bnd::Bathymetry,
    x_lo::Real,
    x_hi::Real
)
    x = range(x_lo, x_hi, 301)
    _, z_hi = OceanSonar.depth_extrema(bnd, x_lo, x_hi)
    z_lower = bnd.(x)
    z_upper = z_hi
    band!(plot,
        x, z_lower, z_upper,
        color = :brown,
        axis = (yreversed = true,)
    )
    return plot
end

function boundaryplot_!(
    plot::Plot, env::Environment, x_lo::Real, x_hi::Real
)
    boundaryplot_!(plot, env.ati, x_lo, x_hi)
    boundaryplot_!(plot, env.bty, x_lo, x_hi)
end

function boundaryplot_!(plot::Plot, scen::Scenario)
    x_lo = 0.0
    x_hi = scen.x
    boundaryplot_!(plot, scen.env, x_lo, x_hi)
end

boundaryplot_!(plot::Plot, args...) = error(
    "No method matching desired signature. Try one of these:\n",
    methods(boundaryplot_!)
)

function Makie.plot!(plot::BoundaryPlot)
    get_plot_arguments(plot) |> splat(boundaryplot_!)
end