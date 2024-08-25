export Environment

@kwdef mutable struct Environment <: OcnSon
	ocn::Medium = Medium()
	sbd::Medium = Medium()
	atm::Medium = Medium()

	alt::Boundary = Boundary()
	bty::Boundary = Boundary()
end

function Environment(::Val{:munk_profile})
    ocn = Ocean(:munk_profile |> Val)
    sbd = Seabed(:clay |> Val)
	atm = Atmosphere(:standard |> Val)

	alt = Altimetry(:flat |> Val)
	bty = Bathymetry(:canonical_deep |> Val)

    Environment(ocn, sbd, atm, alt, bty)
end