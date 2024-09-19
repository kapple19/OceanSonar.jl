#set document(
	title: [Hello],
	author: "Aaron kaw",
	date: auto
)

#show raw.where(block: true): block.with(
  fill: luma(220),
  inset: 10pt,
  radius: 4pt,
)

#import "@preview/jlyfish:0.1.0": *

#read-julia-output(json("OceanSonarCoordinates-jlyfish.json"))
#jl-pkg(
	"InteractiveUtils",
	"Test",
	"Supposition"
)

#align(center, text(17pt)[
  *Ocean Sonar Coordinates*
])

#outline()

#show heading.where(level: 1): it => {pagebreak(weak: false);it}

#set heading(numbering: "1.")

= Preparation

#jl(code: true,
```julia
using InteractiveUtils
using Test
using Supposition

import Core: String
```)

== Coordinate Type System Hierarchy

#jl(code: true,
```julia
abstract type AbstractCoordinate end

struct NonSpatial <: AbstractCoordinate end
struct Abscissa <: AbstractCoordinate end
struct Ordinate <: AbstractCoordinate end
struct Height <: AbstractCoordinate end
struct Depth <: AbstractCoordinate end
struct Range <: AbstractCoordinate end
struct Radius <: AbstractCoordinate end
struct Azimuth <: AbstractCoordinate end
struct Elevation <: AbstractCoordinate end
struct Declination <: AbstractCoordinate end
```)

Some formatting niceties:

#jl(code: true,
```julia
function String(::Type{AC}) where {AC <: AbstractCoordinate}
	str = string(AC)
	idx = findlast('.', str)
	return str[idx+1 : end]
end

String(::AC) where {AC <: AbstractCoordinate} = String(AC)
```)

= 1D $arrow$ 1D

== Enabling Conveniences

#jl(code: true,
```julia
function transform(old::Tuple{<:AbstractCoordinate}, new::Tuple{<:AbstractCoordinate}, v::Real)
	transform(old[1], new[1], v)
end
```)

== Identity Conversions

#jl(code: true,
```julia
function transform(::AC, ::AC, v::Real) where {AC <: AbstractCoordinate}
	return v
end
```)

=== Tests

#jl(code: true,
```julia
@testset "Identity Conversions" begin
	@testset "$(CT |> String)" for CT in subtypes(AbstractCoordinate)
		C = CoordinateType()
		@check function identity_transformation(v = Data.Floats())
			[
				v
				transform(C, C, v)
				transform((C,), (C,), v)
			] |> allequal
		end
	end
end
```)

== Reflection Conversions

#jl(code: true,
```julia
function transform(::Height, ::Depth, z::Real)
	return -z
end

function transform(::Depth, ::Height, z::Real)
	return -z
end

function transform(::Elevation, ::Declination, ϕ::Real)
	return -ϕ
end

function transform(::Declination, ::Elevation, ϕ::Real)
	return -ϕ
end
```)

=== Tests

#jl(code: true,
```julia
@testset "Reflective Conversions" begin
	CoordinatePairs = (
		Vertical = (Depth, Height),
		Polar = (Elevation, Declination)
	)
	@testset "$PairType" for PairType in keys(CoordinatePairs)
		(C1, C2) = CoordinatePairs[PairType]
		@check function reflective_transformation(v = Data.Floats())
			transform(C1(), C2(), v) == -transform(C2(), C1(), v)
		end
	end
end
```)

= 1D $arrow$ 2D

Of course, conversions from 1D of information to 2D is non-unique.

= 2D $arrow$ 1D

#jl(code: true,
```julia
function transform(::Tuple{Abscissa, Ordinate}, ::Tuple{Range}, x::Real, y::Real)
	hypot(x, y)
end

function transform(::Tuple{Range, Azimuth}, ::Tuple{Abscissa}, r::Real, θ::Real)
	r * cos(θ)
end

function transform(::Tuple{Range, Azimuth}, ::Tuple{Ordinate}, r::Real, θ::Real)
	r * sin(θ)
end

function transform(::Tuple{Range, Height}, ::Tuple{Radius}, r::Real, z::Real)
	hypot(r, z)
end

function transform(::Tuple{Range, Height}, ::Tuple{Elevation}, r::Real, z::Real)
	atand(z, r)
end
```)

= 2D $arrow$ 2D

#jl(code: true,
```julia
CoordinatePairs = [
	(:Range, :Azimuth, :Abscissa, :Ordinate),
	(:Radius, :Elevation, :Range, :Height)
]

for (A1, A2, B1, B2) in CoordinatePairs
	@eval function transform(
		a::Tuple{$A1, $A2},
		b::Tuple{$B1, $B2},
		vA1::Real, vA2::Real
	)
		(
			transform(a, b[1], vA1, vA2),
			transform(a, b[2], vA1, vA2)
		)
	end

	@eval function transform(
		B::Tuple{$B1, $B2},
		A::Tuple{$A1, $A2},
		vN1::Real, vN2::Real
	)
		(
			transform(b, a[1], vB1, vB2),
			transform(b, a[2], vB1, vB2)
		)
	end
end
```)

#jl(code: true,
```julia
# transform((Range(), Azimuth()), (Abscissa(), Ordinate()), 1e3, 45)
methods(transform)
```)

== Tests

=== Inverse Conversions

#jl(code: true,
```julia
@testset "Conversion Inverses" begin
	C1 = (Range(), Azimuth())
	C2 = ()
end
```)
