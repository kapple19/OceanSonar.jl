colourmap(::OceanSonar.Celerity) = :Blues

@recipe function _(biv::Bivariate; Nx = 301, Nz = 251)
    x_lim = get(plotattributes, :xlims, (0.0, 1e3))
    z_lim = get(plotattributes, :ylims, (0.0, 1e3))

    x = range(x_lim..., Nx)
    z = range(z_lim..., Nz)

    seriestype --> :heatmap
    legend --> :none
    yflip --> true
    colormap --> colourmap(biv)

    x, z, (x, z) -> biv(x, z)
end

visual!(biv::Bivariate; kw...) = plot!(biv; kw...)
