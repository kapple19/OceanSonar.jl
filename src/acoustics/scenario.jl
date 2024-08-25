export Scenario

"""
TODO.
"""
@kwdef mutable struct Scenario <: Container
    model::Val

    env::Environment

    x::Float64
    z::Float64
    f::Float64
end

Scenario(model::Val{:lloyd_mirror}) = Scenario(
    model = model,
    env = Environment(:lloyd_mirror),
    x = 500.0,
    z = 25.0,
    f = 150.0
)

Scenario(model::Val{:munk_profile}) = Scenario(
    model = model,
    env = Environment(:munk_profile),
    x = 100e3,
    z = 1e3,
    f = 500.0
)

Scenario(model::Val{:index_squared_profile}) = Scenario(
    model = model,
    env = Environment(:index_squared_profile),
    x = 3.5e3,
    z = 1e3,
    f = 100.0
)

Scenario(model::Val{:parabolic_bathymetry}) = Scenario(
    model = model,
    env = Environment(:parabolic_bathymetry),
    x = 20e3,
    z = 0.0,
    f = 1e2
)

@parse_models Scenario

function depth_extrema(bnd::Boundary, x_lo::Real, x_hi::Real)
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
    env::Environment,
    x_lo::Real,
    x_hi::Real
) = depth_extrema(env.ati, env.bty, x_lo, x_hi)

depth_extrema(
    scen::Scenario,
    x_lo::Real = 0.0,
    x_hi::Real = scen.x
) = depth_extrema(scen.env, x_lo, x_hi)