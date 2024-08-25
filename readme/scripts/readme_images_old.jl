# TODO: Automate readme.md generation

##
using OceanSonar
using Plots

scen = Scenario("Munk Profile")
prop = Propagation("Trace", scen, angles = critical_angles(scen))
fig = visual(prop)
savefig(fig, "img/vis_munk_profile.svg")

##
using OceanSonar
using Symbolics
using Latexify

@variables x z

c_eqn = ocean_celerity("Munk", x, z)

c_eqn |> latexify |> render

##
using OceanSonar

@code_lowered bathymetry("Parabolic", 0)

##
using OceanSonar
using Plots

scen = Scenario("Munk Profile")
scen.z = 3000.0
prop = Propagation("Trace", scen, angles = critical_angles(scen))

fig = visual(prop)

savefig(fig, "img/vis_munk_profile_3000.svg")

##
using OceanSonar
using Plots

scen = Scenario("Munk Profile")
prop = Propagation("Trace", scen, angles = critical_angles(scen, N = 21))

fig = visual(Beam, prop)

savefig(fig, "img/munk_profile_rays.svg")

##
using OceanSonar
using Plots

scen = Scenario("Parabolic Bathymetry")
lowest_angle = atan(1, 5)
highest_angle = atan(5, 2)
angles = angles = range(lowest_angle, highest_angle, 31)
prop = Propagation("Trace", scen, angles = angles)

fig = visual(Beam, prop)

savefig(fig, "img/parabolic_bathymetry_rays.svg")

##
using OceanSonar
import OceanSonar: ocean_celerity

ocean_celerity(::Val{:custom_profile}, x, z) = 1500.0 + sin(x*z/1e6)

cel = OceanCelerity("Custom Profile")

fig = visual(cel, xlim = (0, 10e3), ylim = (0, 5e3))

savefig(fig, "img/custom_celerity_profile.svg")

##
using OceanSonar
using Base.Threads

@info "Number of threads: $(nthreads())"

@time "All" begin
    models = list_models(Scenario)
    @threads for m in eachindex(models)
        model = models[m]
        scen = Scenario(model)
        prop = @time "$model" Propagation("Trace", scen,
            angles = critical_angles(scen)
        )
    end
end
