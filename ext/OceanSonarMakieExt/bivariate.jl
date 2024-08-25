function convert_arguments(plot::GridBased,
    biv::Bivariate,
    x::AbstractVector{<:Real},
    z::AbstractVector{<:Real}
)
    b = [biv(x̂, ẑ) for x̂ in x, ẑ in z]
    convert_arguments(plot, x, z, b)
end

function visual!(pos::GridPosition,
    biv::Bivariate,
    x::AbstractVector{<:Real},
    z::AbstractVector{<:Real}
)
    plot = heatmap!(pos[1, 1], biv, x, z,
        colormap = OceanSonar.colour(biv)
    )
    axis = current_axis()
    axis.title = modeltitle(biv) * " Model"
    Colorbar(pos[1, 2], plot,
        label = OceanSonar.label(biv)
    )
    return axis
end

function visual!(pos::GridPosition,
    type::Type{<:Bivariate},
    med::Medium,
    x::AbstractVector{<:Real},
    z::AbstractVector{<:Real}
)
    return visual!(pos, get(med, type), x, z)
end

get_medium(slc::Slice, ::Type{<:OceanCelerity}) = slc.ocn
get_medium(slc::Slice, ::Type{<:OceanDensity}) = slc.ocn

function visual!(pos::GridPosition,
    type::Type{<:Bivariate},
    slc::Slice,
    x::AbstractVector{<:Real},
    z::AbstractVector{<:Real}
)
    axis = visual!(pos, type, get_medium(slc, type), x, z)
    visual!(pos, Boundary, slc, x)
    return axis
end

function visual!(pos::GridPosition,
    type::Type{<:Bivariate},
    scen::Scenario,
    x::AbstractVector{<:Real},
    z::AbstractVector{<:Real}
)
    axis = visual!(pos, type, scen.slc, x, z)
    axis.title = modeltitle(scen)
    return axis
end

function visual!(pos::GridPosition,
    type::Type{<:Bivariate},
    scen::Scenario,
    Nx::Integer,
    Nz::Integer
)
    x = OceanSonar.create_ranges(0.0, scen.x, Nx)
    z = range(depth_extrema(scen)..., Nz)
    return visual!(pos, type, scen.slc, x, z)
end

function visual!(pos::GridPosition,
    type::Type{<:Bivariate},
    prop::Propagation
)
    return visual!(pos, type, prop.scen, prop.x, prop.z)
end
