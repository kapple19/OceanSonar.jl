import OceanSonar: celerityplot!, celerityplot

@recipe(CelerityPlot) do scene
    Theme()
end

function celerityplot_!(plot::Plot,
    cel::OceanCelerity,
    x_lo::Real, x_hi::Real, z_lo::Real, z_hi::Real
)
    x = range(x_lo, x_hi, 301)
    z = range(z_lo, z_hi, 201)
    contourf!(plot,
        x, z, (x, z) -> cel(x, z),
        colormap = :blues,
        axis = (yreversed = true,)
    )
end

function celerityplot_!(plot::Plot,
    ocn::Ocean,
    x_lo::Real, x_hi::Real, z_lo::Real, z_hi::Real
)
    celerityplot_!(plot, ocn.cel, x_lo, x_hi, z_lo, z_hi)
end

function celerityplot_!(plot::Plot, env::Environment, x_lo::Real, x_hi::Real)
    z_lo, z_hi = OceanSonar.depth_extrema(env, x_lo, x_hi)
    celerityplot_!(plot, env.ocn, x_lo, x_hi, z_lo, z_hi)
    boundaryplot!(plot, env.ati, x_lo, x_hi)
    boundaryplot!(plot, env.bty, x_lo, x_hi)
    return plot
end

function celerityplot_!(plot::Plot, scen::Scenario)
    celerityplot_!(plot, scen.env, 0, scen.x)
    return plot
end

celerityplot_!(::Plot, args...) = error(
    "No method matching desired signature. Try one of these:\n",
    methods(celerityplot_!)
)

function Makie.plot!(plot::CelerityPlot)
    get_plot_arguments(plot) |> splat(celerityplot_!)
end