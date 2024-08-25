@recipe(BoundaryVisual, x1, xN) do scene
    Theme()
end

function Makie.plot!(vis::BoundaryVisual)
    band!(
        vis
    )
end