import OceanSonar: boundaryplot!, boundaryplot

## Convert Boundary Instances to Plotting Data

function convert_arguments(plot::PointBased, bnd::Boundary, x::AbstractVector{<:Real})
    return convert_arguments(plot, x, x .|> bnd)
end

function convert_arguments(plot::Type{<:Band}, ati::Altimetry, x::AbstractVector{<:Real})
    x_lo, x_hi = extrema(x)
    z_lo, _ = depth_extrema(ati, x_lo, x_hi)
    z_hi = x .|> ati
    return convert_arguments(plot, x, z_lo, z_hi)
end

function convert_arguments(plot::Type{<:Band}, bty::Boundary, x::AbstractVector{<:Real})
    x_lo, x_hi = extrema(x)
    _, z_hi = depth_extrema(bty, x_lo, x_hi)
    z_lo = bty.(x)
    return convert_arguments(plot, x, z_lo, z_hi)
end

## Boundary Data Pipeline

function visual!(pos::GridPosition, bnd::Boundary, x::AbstractVector{<:Real})
    band!(pos[1, 1], bnd, x,
        color = OceanSonar.colour(bnd)
    )
    return current_axis()
end

function visual!(pos::GridPosition, ::Type{Altimetry}, slc::Slice, x::AbstractVector{<:Real})
    return visual!(pos, slc.ati, x)
end

function visual!(pos::GridPosition, ::Type{Bathymetry}, slc::Slice, x::AbstractVector{<:Real})
    return visual!(pos, slc.bty, x)
end

function visual!(pos::GridPosition, ::Type{Boundary}, slc::Slice, x::AbstractVector{<:Real})
    visual!(pos, Altimetry, slc, x)
    visual!(pos, Bathymetry, slc, x)
    return current_axis()
end

function visual!(pos::GridPosition, type::Type{<:Boundary}, scen::Scenario, x::AbstractVector{<:Real})
    return visual!(pos, type, scen.slc, x)
end

function visual!(pos::GridPosition, type::Type{<:Boundary}, scen::Scenario, Nx::Integer)
    x = OceanSonar.create_ranges(0.0, scen.x, Nx)
    return visual!(pos, type, scen, x)
end

function visual!(pos::GridPosition, type::Type{<:Boundary}, prop::Propagation)
    return visual!(pos, type, prop.scen, prop.x)
end