colour(obs::Observable) = obs.val |> colour

function OceanAxis(pos::GridPosition)
    axis = Axis(pos[1, 1],
        yreversed = true,
        xlabel = "Range [m]",
        ylabel = "Depth [m]"
    )
    return axis
end

function visual(args...)
    fig = Figure()
    pos = fig[1, 1]
    OceanAxis(pos)
    visual!(pos, args...)
    return fig
end
