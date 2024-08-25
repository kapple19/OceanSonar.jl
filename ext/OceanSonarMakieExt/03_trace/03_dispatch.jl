function visual!(pos::GridPosition, beams::Union{<:Fan, <:Beam, <:AbstractVector{<:Beam}})
    series!(pos[1, 1], beams,
        solid_color = :black
    )
    return current_axis()
end