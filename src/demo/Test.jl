## Preamble
using Plots

include("../AcousticPropagation.jl")

## n²-Linear Profile
c₀ = 1550
z₀ = 1e3
f = 2e3
src = AcousticPropagation.Source(AcousticPropagation.Position(0, z₀), AcousticPropagation.Signal(f))
ocn = AcousticPropagation.Medium((r, z) -> c₀/sqrt(1 + 2.4z/c₀), 3.5e3)
bty = AcousticPropagation.Boundary(z₀)
θ₀ = -acos(ocn.c(0, z₀)/ocn.c(0, 150))
θ₀s = θ₀.*(0:0.5:1)

ray = AcousticPropagation.Ray.(θ₀, src, ocn, bty)

plot(yaxis = :flip)
plot!(ray.Sol, vars = (1, 2))

## n²-Linear Profile (a)
c₀ = 1550
z₀ = 1e3
f = 2e3
src = AcousticPropagation.Source(AcousticPropagation.Position(0, z₀), AcousticPropagation.Signal(f))
ocn = AcousticPropagation.Medium((r, z) -> c₀/sqrt(1 + 2.4z/c₀), 3.5e3)
bty = AcousticPropagation.Boundary(z₀)
θ₀ = -acos(ocn.c(0, z₀)/ocn.c(0, 150))

δθ₀ = π/40
# ray = AcousticPropagation.Ray(θ₀, src, ocn, bty)
beam = AcousticPropagation.Beam(θ₀, src, ocn, bty)
TL(s, n) = -20log10(abs(beam.b(s, n)))

s = range(0, beam.S, length = 400)
n = 300.0.*range(-1, 1, length = 400)

heatmap(s, n, TL,
	seriescolor = cgrad(:jet, rev = true))

