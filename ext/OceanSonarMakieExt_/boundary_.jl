import OceanSonar: boundaryplot!, boundaryplot

function ribbon_data(ati::Altimetry, x_lo::Real = 0.0, x_hi::Real = 1e3)
    x = range(x_lo, x_hi, 301)
    z_lo, _ = OceanSonar.depth_extrema(ati, x_lo, x_hi)
    z_hi = ati.(x)
    return x, z_lo, z_hi
end

function ribbon_data(bty::Bathymetry, x_lo::Real = 0.0, x_hi::Real = 1e3)
    x = range(x_lo, x_hi, 301)
    _, z_hi = OceanSonar.depth_extrema(bty, x_lo, x_hi)
    z_lo = bty.(x)
    return x, z_lo, z_hi
end

@recipe(BoundaryPlot) do scene
    Theme()
end

function boundaryplot_!(
    plot::Plot,
    bnd::Boundary,
    x_lo::Real = 0.0,
    x_hi::Real = 1e3
)
    band!(plot,
        ribbon_data(bnd, x_lo, x_hi)...,
        color = OceanSonar.colour(bnd),
        axis = (yreversed = true,) # doesn't work in low-level Makie processing
    )
    return plot
end

function boundaryplot_!(
    plot::Plot,
    slc::Slice,
    x_lo::Real = 0.0,
    x_hi::Real = 1e3
)
    boundaryplot_!(plot, slc.bnd, x_lo, x_hi)
end

function boundaryplot_!(plot::Plot, scen::Scenario)
    x_lo = 0.0
    x_hi = scen.x
    boundaryplot_!(plot, scen.slc, x_lo, x_hi)
end

boundaryplot_!(::Plot, args...) = error(
    "No method matching desired signature for", args, ".\n",
    "Try one of these:\n",
    methods(boundaryplot_!)
)

function Makie.plot!(plot::BoundaryPlot)
    get_plot_arguments(plot) |> splat(boundaryplot_!)
end

function visual!(bnd::Boundary, args...; kw...)
    plot = boundaryplot!(bnd, args...; kw...)
    ax = current_axis()
    ax.yreversed = true
    return current_figure()
end