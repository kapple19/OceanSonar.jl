using OceanSonar
using CairoMakie

scen = Scenario("Parabolic Bathymetry")
lowest_angle = atan(1, 5)
highest_angle = atan(5, 2)
angles = angles = range(lowest_angle, highest_angle, 31)
prop = Propagation("Trace", scen, angles = angles)

visual(Beam, prop)