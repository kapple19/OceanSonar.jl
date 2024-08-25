function convert_arguments(::GridBased, prop::Propagation)
    prop.x, prop.z, prop.PL
end

colour(any::Any) = OceanSonar.colour(any)
colour(prop::Propagation) = OceanSonar.colour(prop) |> Reverse

function visual!(pos::GridPosition, prop::Propagation)
    plot = heatmap!(pos[1, 1], prop,
        colormap = colour(prop),
        colorrange = OceanSonar.colourrange(prop)
    )
    axis = current_axis()
    visual!(pos, Boundary, prop)
    Colorbar(pos[1, 2], plot,
        label = "Propagation Loss [dB re m²]"
    )
    return axis
end