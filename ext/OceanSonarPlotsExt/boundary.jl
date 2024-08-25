boundary_outermost(::Altimetry, z_lo, z_hi) = z_lo
boundary_outermost(::Bathymetry, z_lo, z_hi) = z_hi

@recipe function _(bnd::OceanSonar.Boundary)
    seriestype := :path
    x_lim = get(plotattributes, :xlims, (0.0, 1e3))
    z_lo, z_hi = OceanSonar.depth_extrema(bnd, x_lim...)
    if z_lo == z_hi
        nothing
    else
        legend --> :none
        yflip --> true
        color --> OceanSonar.colour(bnd)
        
        fillrange := boundary_outermost(bnd, z_lo, z_hi)

        x -> bnd(x)
    end
end

visual!(bnd::Boundary; kw...) = plot!(bnd; kw...)