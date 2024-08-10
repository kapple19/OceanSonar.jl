@recipe(BathymetryBand, bty, r_min, r_max) do scene
    Theme()
end

function plot!(plot::BathymetryBand{<:Tuple{<:Function, <:Real, <:Real}})
    r_ntv = interval(plot.r_min[], plot.r_max[])
    z_max = r_ntv |> plot.bty[] |> sup
    r = range(plot.r_min[], plot.r_max[], 301)

    band!(plot,
        r,
        r .|> plot.bty[],
        fill(z_max, length(r)),
        color = :sienna
    )

    return plot
end
