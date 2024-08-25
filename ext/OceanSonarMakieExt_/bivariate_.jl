import OceanSonar: bivariateplot!, bivariateplot

@recipe(BivariatePlot) do scene
    Theme()
end

function bivariateplot_!(
    plot::Plot,
    biv::Bivariate,
    x_lo::Real = 0.0, x_hi::Real = 1e3,
    z_lo::Real = 0.0, z_hi::Real = 5e3
)
    x = range(x_lo, x_hi, 301)
    z = range(z_lo, z_hi, 251)

    heatmap!(plot,
        x, z, (x, z) -> biv(x, z),
        colormap = OceanSonar.colour(biv),
        axis = (yreversed = true,) # doesn't work in low-level Makie processing
    )
end

bivariateplot_!(::Plot, args...) = error(
    "No method matching desired signature for", args, ".\n",
    "Try one of these:\n",
    methods(bivariateplot_!)
)

function Makie.plot!(plot::BivariatePlot)
    get_plot_arguments(plot) |> splat(bivariateplot_!)
end

function visual!(biv::Bivariate, args...; kw...)
    plt = bivariateplot!(biv, args...; kw...)
    ax = current_axis()
    ax.yreversed = true
    fig = current_figure()
    Colorbar(fig[1, end+1], plt)
    return current_figure()
end