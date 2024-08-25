## Transmission Loss Demonstration

## Preamble
using Plots

## Lloyds Mirror
include("../LloydsMirror.jl")

f = 150.
r_src = 0.
z_src = 25.
z = range(0, 4e2, length = 500)
r = range(0, 5e3, length = 500)
c = 1500.

TL(r, z) = LloydsMirror.lloydsmirror_singlereflection.(c, f, r_src, r, z_src, z)

ptField = heatmap(r, z, TL,
	seriescolor = cgrad(:jet, rev = true),
	title = "TL (dB)",
	yaxis = (:flip, "Depth (m)"),
	xaxis = ("Range (m)"))
display(ptField)
savefig(pt, "img/SoundField_LloydsMirror_Simple.png")

ptSlice = plot(r, r -> TL(r, 200.),
	yaxis = :flip)
plot!(r, r -> 20log10(r))
display(ptSlice)
savefig(ptSlice, "img/SoundField_LloydsMirror_Simple_Slice.png")