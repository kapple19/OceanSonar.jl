"""
`Surface`
"""
mutable struct Surface <: Oac
	"Depth of ocean surface"
	z::Function

	"Surface reflection coefficient"
	R::Complex

	function Surface(zFcn::Function, R::Number)
		z(r) = zFcn(r)
		new(z, ComplexF64(R))
	end
end

Surface(z::Real, R::Number) = Surface(r -> z, R |> ComplexF64)

Surface(srf::Surface) = srf

Surface() = Surface(0, -1 |> Complex)

Surface(args) = Surface(args...)

"""
`Bottom`
"""
mutable struct Bottom <: Oac
	"Depth of ocean bottom"
	z::Function

	"Bottom reflection coefficient"
	R::Complex

	function Bottom(zFcn::Function, R::Number)
		z(r) = zFcn(r)
		new(z, Complex(R))
	end
end

Bottom(z::Real, args...) = Bottom(r -> z, args...)

Bottom(btm::Bottom) = btm

Bottom(args) = Bottom(args...)

"""
`Ocean`
"""
mutable struct Ocean <: Oac
	c::Function
	Ocean(c::Function) = new((r, z) -> c(r, z))
end

function Ocean(c::Real)
	Ocean((r, z) -> c)
end

function Ocean(z::AbstractVector{<:Real}, c::AbstractVector{<:Real})
	c_interp = linear_interpolation(z, c, extrapolation_bc = Line())
	c_fcn(r, z) = c_interp(z)
	Ocean(c_fcn)
end

Ocean(ocn::Ocean) = ocn

# Ocean(ocn) = Ocean(ocn...)

"""
`Environment`
"""
mutable struct Environment <: Oac
	ocn::Ocean
	btm::Bottom
	srf::Surface

	function Environment(ocn::Ocean, btm::Bottom, srf::Surface = Surface())
		new(ocn, btm, srf)
	end
end

function Environment(ocn, btm, srf = Surface())
	Environment(Ocean(ocn), Bottom(btm), Surface(srf))
end

Environment(env::Environment) = env

Environment(env) = Environment(env...)

"""
`Source`
"""
mutable struct Source <: Oac
	f::Float64
	z::Float64
end

Source(src::Source) = src

Source(src) = Source(src...)

"""
`Receiver`
"""
mutable struct Receiver <: Oac
	r::Float64

	Receiver(r::Real) = new(r |> Float64)
end

Receiver(rcv::Receiver) = rcv

"""
`Entities`
"""
mutable struct Entities <: Oac
	src::Source
	rcv::Receiver

	function Entities(src, rcv)
		new(Source(src), Receiver(rcv))
	end
end

Entities(ent::Entities) = ent

Entities(ent) = Entities(ent...)

"""
`Scenario`
"""
mutable struct Scenario <: Oac
	env::Environment
	ent::Entities
	name::String

	function Scenario(env, ent, name = "")
		new(Environment(env), Entities(ent), name)
	end
end

Scenario(scn::Scenario) = scn

Scenario(scn) = Scenario(scn...)

function calc_bnd_range(scn::Scenario, bnd::Symbol)
	r_rng = 0.0 .. scn.ent.rcv.r
	z_rng = getproperty(scn.env, bnd).z(r_rng)
	z_rng_int = if !(z_rng isa Interval)
		Interval(z_rng, z_rng)
	else
		z_rng
	end
	z_rng_int.lo, z_rng_int.hi
end

calc_ocean_depth_range(scn::Scenario) = [
	calc_bnd_range(scn, :srf) |> minimum
	calc_bnd_range(scn, :btm) |> maximum
]

mutable struct Field
	r::Vector{Float64}
	z::Vector{Float64}
	PL::Matrix{Float64}
end