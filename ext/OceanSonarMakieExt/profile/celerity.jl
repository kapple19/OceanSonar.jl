@recipe(CelerityHeatmap, ati, r_min, r_max, z_min, z_max) do scene
    Theme()
end

function plot!(plot::CelerityHeatmap{<:Tuple{<:Function, <:Real, <:Real, <:Real, <:Real}})
    r = range(plot.r_min[], plot.r_max[], 301)
    z = range(plot.z_min[], plot.z_max[], 301)

    heatmap!(plot,
        r,
        z,
        [plot.ati[](r′, z′) for r′ in r, z′ in z],
        colormap = :Blues
    )
end
