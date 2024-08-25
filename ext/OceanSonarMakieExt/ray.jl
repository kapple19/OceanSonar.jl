function ray_series_data(beam::Beam)
    arc = OceanSonar.default_arc_points(beam)
    return [
        Point2(beam.x(s), beam.z(s))
        for s in arc
    ]
end

function convert_arguments(plot::Type{<:Series}, beams::AbstractVector{<:Beam})
    convert_arguments(plot, [ray_series_data(beam) for beam in beams])
end

function convert_arguments(plot::Type{<:Series}, beam::Beam)
    convert_arguments(plot, [beam])
end

function visual!(pos::GridPosition, beams::AbstractVector{<:Beam})
    series!(pos[1, 1], beams,
        solid_color = OceanSonar.colour(beams)
    )
    return current_axis()
end

visual!(pos::GridPosition, beam::Beam) = visual!(pos, [beam])

function visual!(pos::GridPosition, ::Type{Beam}, prop::Propagation)
    visual!(pos, OceanCelerity, prop)
    visual!(pos, Boundary, prop)
    axis = visual!(pos, prop.beams)
    axis.title = modeltitle(prop.scen)
    return axis
end