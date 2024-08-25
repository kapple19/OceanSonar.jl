function visual!(pos::GridPosition, bnd::Boundary, args...)
    band!(pos[1, 1], bnd, args...,
        color = OceanSonar.colour(bnd)
    )
    return current_axis()
end