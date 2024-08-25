## Pressure Field Demonstration

## Preamble
using Plots

include("../AcousticPropagation.jl")

## Lloyds Mirror


## Convergence Zone
cVec = [1520, 1500, 1515, 1495, 1545.]
zVec = [0., 300., 1200., 2e3, 5000.]

cMat = vcat([0 0 250e3], hcat(zVec, cVec, cVec))

ati = AcousticPropagation.Boundary(0)
bty = AcousticPropagation.Boundary(5e3)
ocn = AcousticPropagation.Medium(cMat, 250e3)
src = AcousticPropagation.Entity(0, 0)
θ_crit = acos(ocn.c(0, 0)/ocn.c(0, 5e3))
# θ₀ = range(0.01θ_crit, θ_crit, length = 10)
θ₀ = θ_crit

ray = AcousticPropagation.Ray(θ₀, src, ocn, bty, ati)

pt = plot(yaxis = :flip)
plot!(ray.Sol, vars = (1, 2), label = "")
display(pt)

## 
s = range(0, ray.S, length = 1000)
plot(s, ray.A₀)