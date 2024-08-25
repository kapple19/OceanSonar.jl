function convert_arguments(plot::PointBased, bnd::Boundary, r::AbstractVector{<:Real})
    return convert_arguments(plot, r, r .|> bnd)
end

function convert_arguments(plot::PointBased, bnd::Boundary, r_lo::Real, r_hi::Real, Nr::Int)
    return convert_arguments(plot, bnd, efficient_sampling(r_lo, r_hi, Nr))
end

function convert_arguments(plot::Type{<:Band}, ati::Altimetry, r::AbstractVector{<:Real})
    z_lo, _ = output_extrema(ati, extrema(r)...)
    z_hi = r .|> ati
    return convert_arguments(plot, r, z_lo, z_hi)
end

function convert_arguments(plot::Type{<:Band}, bty::Bathymetry, r::AbstractVector{<:Real})
    _, z_hi = output_extrema(bty, extrema(r)...)
    z_lo = r .|> bty
    return convert_arguments(plot, r, z_lo, z_hi)
end

function convert_arguments(plot::Type{<:Band}, bnd::Boundary, r_lo::Real, r_hi::Real, Nr::Int)
    r = efficient_sampling(bnd, r_lo, r_hi, Nr)
    return convert_arguments(plot, bnd, r)
end
