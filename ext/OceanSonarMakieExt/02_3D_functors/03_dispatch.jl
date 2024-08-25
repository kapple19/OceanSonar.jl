function visual!(pos::GridPosition,
    modelling_functor::OceanSonar.ModellingFunctor{3},
    r::AbstractVector{<:Real},
    z::AbstractVector{<:Real}
)
    plot = heatmap!(pos[1, 1], modelling_functor, r, z,
        colormap = OceanSonar.colour(modelling_functor)
    )
    axis = current_axis()
    axis.title = modelpretty(modelling_functor, modelling_functor.model) * " Model"
    Colorbar(pos[1, 2], plot,
        label = OceanSonar.label(modelling_functor)
    )
    return axis
end
