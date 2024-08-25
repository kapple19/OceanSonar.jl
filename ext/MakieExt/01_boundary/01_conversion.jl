# function convert_arguments(plot::Type{<:Band}, ati::Altimetry, r_lo::Real, r_hi::Real, Nr::Int)
#     z_lo, _ = depth_extrema(ati, r_lo, r_hi)
#     x = efficient_sampling(ati)
#     z_hi = x .|> ati
#     return convert_arguments(plot, x, z_lo, z_hi)
# end

# function convert_arguments(plot::Type{<:Band}, bty::Boundary, r_lo::Real, r_hi::Real, Nr::Int)
#     _, z_hi = depth_extrema(bty, x_lo, x_hi)
#     x = efficient_sampling(bty)
#     z_lo = x .|> bty
#     return convert_arguments(plot, x, z_lo, z_hi)
# end