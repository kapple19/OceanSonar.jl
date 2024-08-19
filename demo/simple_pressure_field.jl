##
using OceanSonar
using CairoMakie

c = 1500.0
f = 150.0
λ = c/f

z₀ = 25.0
z = 200.0
# z_bot = z + z₀
z_bot = 2z

r = range(0, 5e3, 401)

fig = Figure()
axis = Axis(fig[1, 1], yreversed = true)

PL = @. pressure_field("Surface Lloyd Mirror", r, z, z₀, λ, c) |> propagation_loss
lines!(axis, r, PL)

PL = @. pressure_field("Bottom Lloyd Mirror", r, z, z₀, z_bot, λ, c) |> propagation_loss
lines!(axis, r, PL)

PL = @. pressure_field("Single Reflection Lloyd Mirror", r, z, z₀, z_bot, λ, c) |> propagation_loss
lines!(axis, r, PL)

display(fig)

##
using OceanSonar
using CairoMakie

c = 1500.0
f = 150.0
λ = c/f

z₀ = 25.0

r = range(0, 5e3, 401)
z = range(0, 2e3, 301)'

PL = @. pressure_field("Surface Lloyd Mirror", r, z, z₀, λ, c) |> propagation_loss
fig, axis, _ = heatmap(r, z', PL)
axis.yreversed = true
display(fig)

##
using OceanSonar
using CairoMakie

scen = Scenario(:SphericalSpreading)

prop = Propagation(:Simple, scen, range(0, 5e3, 401), [0.0], [200.0])

lines(prop.r, prop.PL)
