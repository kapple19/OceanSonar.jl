## Dependencies
using DataInterpolations
using ForwardDiff
using OrdinaryDiffEqTsit5
using GLMakie

## Bathymetry
# TODO.

## Sound Speed Profile
ranges = 1e3 * [0, 12.5, 25.0, 37.5, 50.0, 75.0, 100, 125.0, 201.0]
depths = 1e3 * [0, 0.2, 0.7, 0.8, 1.2, 1.5, 2, 3, 4, 5]
sound_speeds = [
	1536 1536 1536 1536 1536 1536 1536 1536 1536
	1506 1508.75 1511.5 1514.25 1517 1520 1524 1528 1528
	1503 1503 1503 1502.75 1502.5 1502 1502 1502 1502
	1508 1507 1506 1505 1504 1503 1501.5 1500 1500
	1508 1506.6 1505 1503.75 1502.5 1500.5 1499 1497 1497
	1497 1497 1497 1497 1497 1497 1497 1497 1497
	1500 1500 1500 1500 1500 1500 1500 1500 1500
	1512 1512 1512 1512 1512 1512 1512 1512 1512
	1528 1528 1528 1528 1528 1528 1528 1528 1528
	1545 1545 1545 1545 1545 1545 1545 1545 1545
	]

itps = [
    LinearInterpolation(sound_speeds[:, n], depths, extrapolate = true)
    for n in eachindex(ranges)
]

rs = copy(ranges)
push!(rs, Inf64)
function sound_speed_profile_(r, z)
    cs = [itp(z) for itp in itps]

    push!(cs, cs[end])
    
    itp = LinearInterpolation(cs, rs, extrapolate = true)
    # @show r
    return itp(r |> abs)
end

myhypot(x, y) = if x == 0
    abs(y)
elseif y == 0
    abs(x)
else
    hypot(x, y)
end

sound_speed_profile(x, y, z) = sound_speed_profile_(myhypot(x, y), z)

## Beam Tracing
struct Beam
    s_max::Float64

    x::Function
    y::Function
    z::Function
end

function beam_ensemble(
    c_ocn::Function,
    src_pos::@NamedTuple{x₀::AbscissaType, y₀::OrdinateType, z₀::DepthType},
    angles::AbstractVector{<:AbstractVector{<:Real}}
) where {
    AbscissaType <: Real,
    OrdinateType <: Real,
    DepthType <: Real
}
    @assert angles .|> length |> unique! == [2]

    cel_grad(pos) = ForwardDiff.gradient(pos -> c_ocn(pos...), pos)

    function trace!(du, u, _, _)
        pos = @view u[1:3]
        tng = @view u[4:6]

        c = c_ocn(pos...)
        ∇c = cel_grad(pos)
        du .= [
            c * tng ...
            -∇c / c^2 ...
        ]
    end

    tng_inits = [
        [
            cos(φ₀) .* [cos(θ₀), sin(θ₀)]...; sin(φ₀)
        ] for (θ₀, φ₀) in angles
    ] / c_ocn(src_pos...)

    function launch_ray(prob, n, _)
        prob.u0[4:6] .= tng_inits[n]
        return prob
    end

    function beam_output(sol, _)
        x(s) = sol(s, idxs = 1)
        y(s) = sol(s, idxs = 2)
        z(s) = sol(s, idxs = 3)

        return Beam(sol.t[end], x, y, z), false
    end

    prob = ODEProblem(trace!, [src_pos...; tng_inits[begin]...], (0, 200e3))
    ens_prob = EnsembleProblem(prob, prob_func = launch_ray, output_func = beam_output)
    ens_sol = solve(ens_prob, Tsit5(), EnsembleThreads(), reltol = 1e-50, trajectories = length(angles))
    return ens_sol.u
    
    # sol = solve(prob, Tsit5(), reltol = 1e-50)
    # return [beam_output(sol, nothing)]
end

function equidistributed_spherical_angles(N)
	a = 4π / N
	d = sqrt(a)
	Mφ = round(π/d)
	dφ = π/Mφ
	dθ = a/dφ

	angles = [[0, -π/2]]
	for m in 0 : Mφ-1
		φ = π * (m + 0.5) / Mφ
		Mθ = round(2π * sin(φ) / dθ)
		for n in  0 : Mθ-1
			θ = 2π * n/Mθ
			push!(angles, [θ - π, φ - π/2])
		end
	end
    push!(angles, [0, π/2])

	return angles
end

angles = equidistributed_spherical_angles(301)
src_pos = (x₀ = -100.0, y₀ = 25.0, z₀ = 1e3)
beams = beam_ensemble(sound_speed_profile, src_pos, angles)

## Interactive Visualisation
fig = Figure()

azimuth_view_slider = Slider(fig[1, 1],
    horizontal = true,
    range = 0:360,
    startvalue = 350
)

azimuth_view = lift(θview -> deg2rad(θview), azimuth_view_slider.value)

axis = Axis3(fig[2, 1],
    zreversed = true,
    azimuth = azimuth_view,
    viewmode = :fit,
    xlabel = "x [km]",
    ylabel = "y [km]",
    zlabel = "z [m]",
    title = "Rays Launched at the Same Azimuth"
)

curves = [
    [
        Point3(beam.x(s) * 1e-3, beam.y(s) * 1e-3, beam.z(s))
        for s in range(0, beam.s_max, 301)
    ] for beam in beams
]

series!(axis, curves, solid_color = :black)

display(fig)
