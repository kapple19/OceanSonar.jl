@recipe function _(prop::Propagation)
    seriestype --> :heatmap
    legend --> :none
    yflip --> true
    colormap --> cgrad(:jet, rev = true)

    prop.x, prop.z, prop.PL'
end

function visual!(prop::Propagation; kw...)
    plot!(prop; kw...)
    visual!(Boundary, prop; kw...)
end

visual!(type::Type{<:Boundary}, prop::Propagation; kw...) = visual!(type, prop.scen; kw...)

visual!(type::Type{<:Bivariate}, prop::Propagation; kw...) = visual!(type, prop.scen; kw...)

function visual!(::Type{Beam}, prop::Propagation; kw...)
    visual!(OceanCelerity, prop; kw...)
    visual!(prop.beams; kw...)
    visual!(Boundary, prop)
end