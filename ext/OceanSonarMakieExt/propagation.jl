import OceanSonar: propagationplot!, propagationplot

@recipe(PropagationPlot) do scene
    Theme()
end

function propagationplot_!(plot::Plot, prop::Propagation)
    heatmap!(plot,
        prop.x, prop.z, prop.PL,
        colorrange = (0, 100),
        colormap = Reverse(:jet),
        axis = (yreversed = true,)
    )
    boundaryplot!(plot, prop.scen)
    return plot
end

function Makie.plot!(plot::PropagationPlot)
    get_plot_arguments(plot) |> splat(propagationplot_!)
end