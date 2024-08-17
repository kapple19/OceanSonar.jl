##
using OceanSonar, GLMakie

interactive_raycurves(
    OceanCelerityProfile(:Munk),
    BathymetryProfile(:Flat, z = 5e3),
    AltimetryProfile(:Flat);
    r_max = 100e3,
    num_rays = 5,
    min_angle = -π/20,
    max_angle = π/20
)

##
using OceanSonar, GLMakie

interactive_raycurves(
    OceanCelerityProfile(:Homogeneous),
    BathymetryProfile("Parabolic"),
    AltimetryProfile(:Flat);
    r_max = 20e3,
    z_src = 0.0,
    num_rays = 5,
    min_angle = atan(5, 20),
    max_angle = atan(5, 2),
)

##
using OceanSonar, GLMakie

cel = OceanCelerityProfile(:Homogeneous)
ati = AltimetryProfile(:Flat)
bty = BathymetryProfile("Parabolic")
Rsrf = ReflectionCoefficientProfile(:Reflective)
Rbot = ReflectionCoefficientProfile(:Mirror)

r_max = 20e3
z_src = 0.0
num_rays = 5
min_angle = atan(5, 20)
max_angle = atan(5, 2)
r_min = 0.0
r_max = 20e3
z_min = OceanSonar.IntervalArithmetic.interval(r_min, r_max) |> ati |> OceanSonar.IntervalArithmetic.inf
z_max = OceanSonar.IntervalArithmetic.interval(r_min, r_max) |> bty |> OceanSonar.IntervalArithmetic.sup
z_src = 0.0

fig = Figure()

axis = Axis(fig[1, 1],
    yreversed = true
)

z₀s = [z_src; range(ati(r_min), bty(r_min), 5)] |> uniquesort! |> reverse

depth_slider = Slider(fig[1, 0],
    range = z₀s,
    horizontal = false,
    startvalue = z_src,
    snap = true
)

φ₀s = range(min_angle, max_angle, num_rays)

function fan2rays(z₀)
    fan = Fan("Gaussian", φ₀s, z₀, r_max, 1e3, cel, bty, Rbot, ati, Rsrf)
    beam2ray.(fan.beams)
end

function beam2ray(beam)
    s = range(0, beam.s_max, 301)
    r = beam.r(s)
    z = beam.z(s)
    Point2.(r, z)
end

rays = Dict(
    z₀ => fan2rays(z₀) for z₀ in z₀s
)

curve = lift(depth_slider.value) do z₀
    rays[z₀]
end

celerityheatmap!(axis, cel, r_min, r_max, z_min, z_max)
altimetryband!(axis, ati, r_min, r_max)
bathymetryband!(axis, bty, r_min, r_max)
series!(axis, curve, solid_color = :black)

limits!(axis, r_min, r_max, z_min, z_max)

axis.yreversed = true

fig
