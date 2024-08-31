//// Preamble

// Uppercase
#let DI = $upright("DI")$
#let NL = $upright("NL")$
#let SE = $upright("SE")$
#let SL = $upright("SL")$
#let TL = $upright("TL")$
#let TS = $upright("TS")$

// Lowercase
#let fft = $upright("fft")$
#let rvb = $upright("rvb")$

// Math
#let log10 = $upright("log10")$

// Setup
#set heading(numbering: "1.")

#import "@preview/jlyfish:0.1.0": *
#read-julia-output(json("sonar_performance-jlyfish.json"))

#jl-pkg(
  "CairoMakie",
  "Typstry"
)

#jl(
```
using CairoMakie
```)

//// Document

#align(center, text(24pt)[*Ocean Sonar*])

= Sonar Oceanography

== Environment

#jl(code: true,
```
struct Environment
  c::Float64
  z_bot::Float64
  S_srf::Float64
  S_vol::Float64
  S_bot::Float64
	NL::Float64
	TS::Float64
end
```)

#jl(code: true,
```
env = Environment(1500.0, 5e3, -5, 0, 5, 15.0, -5.0)
```)

== Grid

#jl(code: true,
```
struct Grid
  x::Vector{Float64}
  y::Vector{Float64}
  z::Vector{Float64}
end

function Base.show(io::IO, grid::Grid)
  print(io, "Grid(")
  print(io, length(grid.x), " × ")
  print(io, length(grid.y), " × ")
  print(io, length(grid.z), ")")
end
```
)

#jl(code: true,
```
grid = Grid(
  range(-5e3, 5e3, 101),
  range(-5e3, 5e3, 41),
  range(0, env.z_bot, 91)
)
```)

= Ocean Acoustics

== Propagation

#jl(code: true,
```
struct Propagation
  PL
  TS
end
```)

=== Tracing

#jl(code: true,
```
struct Ray
  x
  y
  z
end
```)

#jl(code: true,
```
struct Trace
  rays::Vector{Ray}
end

function Trace()

end
```)
