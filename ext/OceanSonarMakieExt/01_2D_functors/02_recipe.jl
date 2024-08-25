# @recipe(BoundaryVisual, x1, xN) do scene
#     Theme(

#     )
# end

# function Makie.plot!(vis::BoundaryVisual)
#     bnd = vis[1]
#     r_lo = vis[2]
#     r_hi = vis[3]
#     Nr = vis[4]

#     band!(vis, bnd, r_lo, r_hi, Nr,
#         color = colour(bnd)
#     )

#     return vis
# end
