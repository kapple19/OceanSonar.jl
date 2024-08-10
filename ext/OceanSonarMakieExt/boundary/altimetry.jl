@recipe(AltimetryBand, ati, r_min, r_max) do scene
    Theme()
end

function plot!(plot::AltimetryBand{<:Tuple{<:Function, <:Real, <:Real}})
    r_ntv = interval(plot.r_min[], plot.r_max[])
    z_min = r_ntv |> plot.ati[] |> inf
    r = range(plot.r_min[], plot.r_max[], 301)

    band!(plot,
        r,
        r .|> plot.ati[],
        fill(z_min, length(r)),
        color = :slateblue1
    )

    return plot
end
