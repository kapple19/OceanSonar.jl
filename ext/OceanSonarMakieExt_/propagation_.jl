import OceanSonar: propagationplot!, propagationplot

@recipe(PropagationPlot) do scene
    Theme()
end

function propagationplot_!(plot::Plot, prop::Propagation)   
    heatmap!(plot,
        prop.x, prop.z, prop.PL,
        colormap = Makie.Reverse(:jet),
        axis = (yreversed = true,) # doesn't work in low-level Makie processing
    )
end

propagationplot_!(::Plot, args...) = error(
    "No method matching desired signature for", args, ".\n",
    "Try one of these:\n",
    methods(propagationplot_!)
)

function Makie.plot!(plot::PropagationPlot)
    get_plot_arguments(plot) |> splat(propagationplot_!)
end

function visual!(type::Type{<:OceanSonar.Functor}, prop::Propagation, args...; kw...)
    visual!(type, prop.scen, args...; kw...)
    return current_figure()
end

function visual!(prop::Propagation; kw...)
    plt = propagationplot!(prop; kw...)
    ax = current_axis()
    ax.yreversed = true
    fig = current_figure()
    Colorbar(fig[1, end+1], plt)

    visual!(Boundary, prop)

    return current_figure()
end

function visual!(::Type{Beam}, prop::Propagation, args...; kw...)
    visual!(prop.beams, args...; kw...)
    visual!(Boundary, prop)

    return current_figure()
end