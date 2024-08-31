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

#jl(code: true,
```
function propagation_loss(p::Complex)
  return -20log10(p |> abs)
end
```)

#jl(code: true, 
```
propagation_loss(1 + 2im)
```)

#jl(code: true,
```
function propagation_loss(k, r_rx, z_rx, z_tx)
  s_direct = hypot(r_rx, z_rx - z_tx)
  s_reflected = hypot(r_rx, z_rx + z_tx)

  p_direct = cis(k*s_direct) / s_direct
  p_reflected = -cis(k*s_reflected) / s_reflected

  p = p_direct + p_reflected
  return propagation_loss(p)
end
```)

#jl(code: true,
```
c = 1500.0
f = 150.0
k = 2pi * f / c

z_tx = 25.0
r_rx_vec = range(0, 5e3, 401)

PL_vec = [
  propagation_loss(k, r_rx, 200, z_tx)
  for r_rx in r_rx_vec
]

fig = Figure()
axis = Axis(fig[1, 1], yreversed = true)

lines!(axis, r_rx_vec, PL_vec)
lines!(axis, r_rx_vec, @. 20log10(r_rx_vec))

fig
```)

#jl(code: true,
```
z_rx_vec = range(0, 5e3, 201)

PL_mat = [
  propagation_loss(k, r_rx, z_rx, z_tx)
  for r_rx in r_rx_vec, z_rx in z_rx_vec
]

fig = Figure()
axis = Axis(fig[1, 1], yreversed = true)

plot = heatmap!(axis, r_rx_vec, z_rx_vec, PL_mat,
  colormap = Reverse(:turbo)
)
Colorbar(fig[1, 2], plot)

fig
```)

= Sonar Signal Processing

== Transmission

#jl(code: true,
```
abstract type TransmissionStatus end

struct Transmitting <: TransmissionStatus end
struct NonTransmitting <: TransmissionStatus end
```)

== Processing

#jl(code: true,
```
mutable struct Processing
  f::Float64
end
```)

== Entities

#jl(code: true,
```
abstract type AbstractEntity end
```)

#jl(code: true,
```
struct AbsentEntity <: AbstractEntity end
```)

#jl(code: true,
```
@kwdef mutable struct Entity{Stat <: TransmissionStatus} <: AbstractEntity
  SL::Float64
  NL::Float64
  DI::Float64
  TS::Float64
  x::Float64 = NaN
  y::Float64 = NaN
  z::Float64 = NaN
end

function Base.show(io::IO, ent::Entity)
  print(io, "Entity(")
  prop_names = propertynames(ent)
  for prop in prop_names
    print(io, prop, " = ", getproperty(ent, prop), prop == prop_names[end] ? "" : ", ")
  end
  print(io, ")")
end
```)

#jl(code: true,
```
function Entity{Stat}(ent::Entity{<:TransmissionStatus}) where {
  Stat <: TransmissionStatus
}
  newent = Entity{Stat}([NaN for _ in fieldnames(Entity)]...)
  for field in fieldnames(Entity)
    setproperty!(newent, field, getproperty(ent, field))
  end
  return newent
end
```)

=== Example Entities

#jl(code: true,
```
ownship = Entity{TransmissionStatus}(100, 10, 11, -1, 0, 0, 25)
```)

#jl(code: true,
```
target = Entity{TransmissionStatus}(200, 20, 22, -2, 5e3, 0, 200)
```)

#jl(code: true,
```
cat = Entity{Transmitting}(300, 30, 33, -3, 0, 10, 50)
```)

== Source Level

#jl(code: true,
```
function source_level(
  own::Entity{Transmitting},
  tgt::Entity{NonTransmitting},
  cat::AbsentEntity = AbsentEntity()
)
  own.SL
end

function source_level(
  own::Entity{NonTransmitting},
  tgt::Entity{NonTransmitting},
  cat::AbsentEntity = AbsentEntity()
)
  tgt.NL
end

function source_level(
  own::Entity{NonTransmitting},
  tgt::Entity{Transmitting},
  cat::AbsentEntity = AbsentEntity()
)
  tgt.SL
end

function source_level(
  own::Entity{NonTransmitting},
  tgt::Entity{NonTransmitting},
  cat::Entity{Transmitting}
)
  cat.SL
end
```)

== Propagation Loss

#jl(code: true,
```
function propagation_loss(
  env::Environment,
  grid::Grid,
  ent::AbsentEntity,
  tgt::Entity
)
  zeros(0.0, length(grid.x), length(grid.y), length(grid.z))
end

function propagation_loss(
  env::Environment,
  grid::Grid,
  own::Entity,
  tgt::Entity
)
  k = 2π * tgt.f / env.c
  r_grid = [hypot(x, y) for x in grid.x, y in grid.y]
  return [
    propagation_loss(k, r, z, tgt.z)
    for r in r_grid, z in grid.z
  ]
end
```)

== Target Strength

#jl(code: true,
```
function target_strength(
  own::Entity{Transmitting},
  tgt::Entity{NonTransmitting},
  cat::AbsentEntity = AbsentEntity()
)
  tgt.TS
end

function target_strength(
  own::Entity{NonTransmitting},
  tgt::Entity{NonTransmitting},
  cat::Entity{Transmitting}
)
  tgt.TS
end

function target_strength(
  own::Entity{NonTransmitting},
  tgt::Entity,
  cat::AbsentEntity = AbsentEntity()
)
  0.0
end
```)

#jl(code: true,
```
function target_strength(
  env::Environment,
  proc::Processing,
  x_rx::Real, y_rx::Real, z_rx::Real,
  z_tx::Real
)
  s = hypot(x_rx, y_rx, z_rx - z_tx)
  10log10(env.c * proc.T * π * s) + if z_rx == 0
    env.S_srf
  elseif z_rx == env.z_bot
    env.S_bot
  else
    env.S_vol
  end
end

function target_strength(
  env::Environment,
  proc::Processing,
  grid::Grid,
  tx::Entity{Transmitting}
)
  return [
    target_strength(env, proc, x, y, z, tx.z)
    for x in grid.x, y in grid.y, z in grid.z
  ]
end
```)
