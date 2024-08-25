@recipe function _(scen::Scenario; ownship_color = :green)
    xlims --> (0.0, scen.x)
    ylims --> OceanSonar.depth_extrema(scen)
    yflip --> true

    seriestype --> :scatter
    markershape --> :star8
    color --> ownship_color
    ((0, scen.z),)
end

function visual!(scen::Scenario; kw...)
    plot!(scen;
        xlims = (0, scen.x),
        ylims = OceanSonar.depth_extrema(scen),
        kw...
    )
    visual!(Boundary, scen; kw...)
end

function visual!(type::Type{<:Boundary}, scen::Scenario; kw...)
    visual!(type, scen.slc;
        xlims = (0, scen.x),
        ylims = OceanSonar.depth_extrema(scen),
        kw...
    )
end

function visual!(type::Type{<:Bivariate}, scen::Scenario; kw...)
    visual!(type, scen.slc;
        xlims = (0, scen.x),
        ylims = OceanSonar.depth_extrema(scen),
        kw...
    )
end