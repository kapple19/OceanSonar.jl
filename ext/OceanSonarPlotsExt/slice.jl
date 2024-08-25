visual!(::Type{Altimetry}, slc::Slice; kw...) = visual!(slc.ati; kw...)
visual!(::Type{Bathymetry}, slc::Slice; kw...) = visual!(slc.bty; kw...)

function visual!(::Type{Boundary}, slc::Slice; kw...)
    visual!(slc.ati; kw...)
    visual!(slc.bty; kw...)
end

# TODO: Automate through `Bivariate`s.

function visual!(::Type{OceanCelerity}, slc::Slice; kw...)
    visual!(Celerity, slc.ocn; kw...)
    visual!(Boundary, slc; kw...)
    plot!(
        colorbar_title = " \n" * "Ocean Sound Speed [m/s]",
        colorbar_title_font_halign = :right
    )
end

function visual!(::Type{OceanDensity}, slc::Slice; kw...)
    visual!(OceanSonar.Density, slc.ocn; kw...)
    visual!(Boundary, slc; kw...)
end

visual!(slc::Slice; kw...) = visual!(OceanCelerity, slc)