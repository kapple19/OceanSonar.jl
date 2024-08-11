##
using OceanSonar
using OceanSonar.IntervalArithmetic
using CairoMakie

cel = OceanCelerityProfile("Munk")
bty = BathymetryProfile("Flat", z = 5e3)
ati = AltimetryProfile("Flat")

r_min = 0.0
r_max = 100e3

fan = Fan("Gaussian",
	π/20 * range(-1, 1, 5),
	1e3, r_max, 1e3,
	cel,
	bty,
	ReflectionCoefficientProfile("Reflective"),
	ati,
	ReflectionCoefficientProfile("Mirror")
)

r_ntv = interval(r_min, r_max)
z_min = r_ntv |> ati |> inf
z_max = r_ntv |> bty |> sup

fig = Figure()
axis = Axis(fig[1, 1], yreversed = true)
celerityheatmap!(axis, cel, r_min, r_max, z_min, z_max)
bathymetryband!(axis, bty, r_min, r_max)
altimetryband!(axis, ati, r_min, r_max)
raycurves!(axis, fan)

display(fig)

##
using OceanSonar
using OceanSonar.IntervalArithmetic
using CairoMakie

cel = OceanCelerityProfile("Homogeneous")
bty = BathymetryProfile("Parabolic")
ati = AltimetryProfile("Flat")

r_min = 0.0
r_max = 20e3

z_ref = 5e3

fan = Fan("Gaussian",
	range(atan(z_ref, r_max), atan(z_ref, r_max/10), 5),
	0.0, r_max, 1e3,
	cel,
	bty,
	ReflectionCoefficientProfile("Reflective"),
	ati,
	ReflectionCoefficientProfile("Mirror")
)

r_ntv = interval(r_min, r_max)
z_min = r_ntv |> ati |> inf
z_max = r_ntv |> bty |> sup

fig = Figure()
axis = Axis(fig[1, 1], yreversed = true)
celerityheatmap!(axis, cel, r_min, r_max, z_min, z_max)
bathymetryband!(axis, bty, r_min, r_max)
altimetryband!(axis, ati, r_min, r_max)
raycurves!(axis, fan)

display(fig)
