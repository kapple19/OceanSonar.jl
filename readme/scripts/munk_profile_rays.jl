using OceanSonar
using CairoMakie

scen = Scenario("Munk Profile")
prop = Propagation("Trace", scen, angles = critical_angles(scen, N = 21))

visual(Beam, prop)