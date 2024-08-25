export Scenario
export depth_extrema

"""
TODO.
"""
@kwdef mutable struct Scenario <: Container
    model::Val

    slc::Slice

    x::Float64
    z::Float64
    f::Float64
end

Scenario(model::Val{:lloyd_mirror}) = Scenario(
    model = model,
    slc = Slice(:lloyd_mirror),
    x = 500.0,
    z = 25.0,
    f = 150.0
)

Scenario(model::Val{:munk_profile}) = Scenario(
    model = model,
    slc = Slice(:munk_profile),
    x = 100e3,
    z = 1e3,
    f = 500.0
)

Scenario(model::Val{:index_squared_profile}) = Scenario(
    model = model,
    slc = Slice(:index_squared_profile),
    x = 3.5e3,
    z = 1e3,
    f = 100.0
)

Scenario(model::Val{:parabolic_bathymetry}) = Scenario(
    model = model,
    slc = Slice(:parabolic_bathymetry),
    x = 20e3,
    z = 0.0,
    f = 1e2
)

Scenario(model::Val{:linearised_convergence_zones}) = Scenario(
    model = model,
    slc = Slice(:linearised_convergence_zones),
    x = 250e3,
    z = 0.0,
    f = 1e3
)

Scenario(model::Val{:norwegian_sea_sound_channel}) = Scenario(
    model = model,
    slc = Slice(:norwegian_sea),
    x = 250e3,
    z = 500.0,
    f = 1e3
)

Scenario(model::Val{:norwegian_sea_surface_duct}) = Scenario(
    model = model,
    slc = Slice(:norwegian_sea),
    x = 40e3,
    z = 40.0,
    f = 1e3
)

@parse_models Scenario

function depth_extrema(bnd::Boundary, x_lo::Real, x_hi::Real)
    x_lo
    x_hi
    z_rng = bnd(x_lo .. x_hi)
    return if z_rng isa Interval
        (
            z_rng.bareinterval.lo,
            z_rng.bareinterval.hi
        )
    else
        (z_rng, z_rng)
    end
end

depth_extrema(
    ati::Altimetry,
    bty::Bathymetry,
    x_lo::Real,
    x_hi::Real
) = (
    depth_extrema(ati, x_lo, x_hi)[1],
    depth_extrema(bty, x_lo, x_hi)[2]
)

depth_extrema(
    slc::Slice,
    x_lo::Real,
    x_hi::Real
) = depth_extrema(slc.ati, slc.bty, x_lo, x_hi)

depth_extrema(
    scen::Scenario,
    x_lo::Real = 0.0,
    x_hi::Real = scen.x
) = depth_extrema(scen.slc, x_lo, x_hi)

depth_minimum(args...) = depth_extrema(args...) |> splat(min)
depth_maximum(args...) = depth_extrema(args...) |> splat(max)

function validate(scen::Scenario)
    @assert scen.slc.ati(0) ≤ scen.z ≤ scen.slc.bty(0)
end