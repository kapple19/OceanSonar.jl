##
using OceanSonar
using OceanSonar.IntervalArithmetic
using CairoMakie

r_min = 0.0
r_max = 100e3

scen = Scenario("Munk Celerity")
fan = Fan("Gaussian",
	π/20 * range(-1, 1, 3),
	scen.own.pos.z, 100e3, 1e3,
	scen.env.ocn.cel,
	scen.env.bot.dpt,
	scen.env.bot.rfl,
	scen.env.srf.dpt,
	scen.env.srf.rfl
)

r_ntv = interval(r_min, r_max)
z_min = r_ntv |> ati |> inf
z_max = r_ntv |> bty |> sup

fig = Figure()
axis = Axis(fig[1, 1], yreversed = true)
celerityheatmap!(axis, scen.env.ocn.cel, r_min, r_max, z_min, z_max)
bathymetryband!(axis, scen.env.bot.dpt, r_min, r_max)
altimetryband!(axis, scen.env.srf.dpt, r_min, r_max)
raycurves!(axis, fan)

display(fig)

##
using OceanSonar
using OceanSonar.IntervalArithmetic
using CairoMakie

r_min = 0.0
r_max = 20e3

z_ref = 5e3

scen = Scenario("Parabolic Bathymetry")
fan = Fan("Gaussian",
	range(atan(z_ref, r_max), atan(z_ref, r_max/10), 5),
	scen.own.pos.z, r_max, 1e3,
	scen.env.ocn.cel,
	scen.env.bot.dpt,
	scen.env.bot.rfl,
	scen.env.srf.dpt,
	scen.env.srf.rfl
)

r_ntv = interval(r_min, r_max)
z_min = r_ntv |> ati |> inf
z_max = r_ntv |> bty |> sup

fig = Figure()
axis = Axis(fig[1, 1], yreversed = true)
celerityheatmap!(axis, scen.env.ocn.cel, r_min, r_max, z_min, z_max)
bathymetryband!(axis, scen.env.bot.dpt, r_min, r_max)
altimetryband!(axis, scen.env.srf.dpt, r_min, r_max)
raycurves!(axis, fan)

display(fig)
