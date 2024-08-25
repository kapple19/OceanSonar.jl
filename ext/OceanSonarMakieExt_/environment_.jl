function visual!(slc::Slice, x_lo::Real, x_hi::Real; kw...)
    visual!(slc.ati, x_lo, x_hi; kw...)
    visual!(slc.bty, x_lo, x_hi; kw...)
    return current_figure()
end

get_boundary(::Type{Altimetry}, slc::Slice) = slc.ati
get_boundary(::Type{Bathymetry}, slc::Slice) = slc.bty

function visual!(type::Type{<:Boundary}, slc::Slice,
    x_lo::Real = 0.0, x_hi::Real = 1e3;
    kw...
)
    @assert isconcretetype(type) "Expecting concrete type request."
    visual!(get_boundary(type, slc), x_lo, x_hi)
    return current_figure()
end

function visual!(type::Type{<:Bivariate}, slc::Slice,
    x_lo::Real = 0.0, x_hi::Real = 1e3;
    kw...
)
    super = supertype(type)
    @assert super ≠ Bivariate
    z_lo, z_hi = OceanSonar.depth_extrema(slc, x_lo, x_hi)
    visual!(super, slc.ocn, x_lo, x_hi, z_lo, z_hi; kw...)
    visual!(slc, x_lo, x_hi)
    return current_figure()
end

function visual!(::Type{Boundary}, slc::Slice,
    x_lo::Real = 0.0, x_hi::Real = 1e3;
    kw...
)
    visual!(slc, x_lo, x_hi; kw...)
    return current_figure()
end