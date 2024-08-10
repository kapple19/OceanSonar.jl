@recipe(BathymetryBand, bty, rmin, rmax) do scene
    Theme()
end

function plot!(plot::BathymetryBand{<:Tuple{<:Function, <:Real, <:Real}})
    bty, r_min, r_max = plot[1:3]
    
    r_ntv = interval(r_min[], r_max[])
    z_max = r_ntv |> bty[] |> sup
    r = range(r_min[], r_max[], 301)
    band!(plot,
        r,
        r .|> bty[],
        fill(z_max, length(r)),
        color = :sienna
    )
end
