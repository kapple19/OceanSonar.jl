export default_angles
export steepest_angle
export minimum_angle
export maximum_angle
export critical_angles
export rayplot!
export rayplot

const DEFAULT_RAY_ARC_SPAN = (0.0, 1e6)

function shallowest_angle(scen::Scenario)
    dz = scen |> depth_extrema |> reverse |> splat(-)
    atan(dz, 200scen.x)
end

function steepest_angle(scen)
    dz = scen |> depth_extrema |> reverse |> splat(-)
    atan(200dz, scen.x) |> abs
end

const DEFAULT_NUM_RAYS = 101

tangent_angle(bnd::Boundary) = derivative(x -> bnd(x), 0) |> atan

function minimum_angle(scen::Scenario)
    if scen.z == scen.env.ati(0)
        tangent_angle(scen.env.ati) + shallowest_angle(scen)
    else
        -steepest_angle(scen)
    end
end

function maximum_angle(scen::Scenario)
    if scen.z == scen.env.bty(0)
        tangent_angle(scen.env.bty) - shallowest_angle(scen)
    else
        steepest_angle(scen)
    end
end

function default_angles(
    scen::Scenario;
    θ_min::Real = minimum_angle(scen),
    θ_max::Real = maximum_angle(scen),
    N::Integer = DEFAULT_NUM_RAYS
)
    return range(θ_min, θ_max, N)
end

function critical_angles(scen::Scenario, N::Integer = DEFAULT_NUM_RAYS)
    z_srf = scen.env.ati(0)
    z_bot = scen.env.bty(0)
    c_srf = scen.env.ocn.cel(0.0, z_srf)
    c_bot = scen.env.ocn.cel(0.0, z_bot)
    c_own = scen.env.ocn.cel(0.0, scen.z)

    θ_min = if scen.z == z_srf || c_own ≥ c_srf
        minimum_angle(scen)
    else
        -snells_law(c_srf, 0.0, c_own)
    end
    
    θ_max = if scen.z == z_bot || c_own ≥ c_bot
        maximum_angle(scen)
    else
        snells_law(c_bot, 0.0, c_own)
    end
    
    return range(θ_min, θ_max, N)
end

function rayplot! end
function rayplot end