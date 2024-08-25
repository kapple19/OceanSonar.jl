function default_angles(scn::Scenario, N::Int = 1001)
	r_rcv = scn.ent.rcv.r
	rng_ocn = calc_ocean_depth_range(scn)

	dz_ocn = diff(rng_ocn)[1]
	θ₀ = atan(dz_ocn / (r_rcv / 10))

	return if scn.ent.src.z == scn.env.srf.z(0.0)
		θ₀ * range(0, 1, N)
	elseif scn.ent.src.z == scn.env.btm.z(0.0)
		θ₀ * range(-1, 0, N)
	else
		θ₀ * range(-1, 1, N)
	end
end

default_ranges(scn::Scenario) = range(0.0, scn.ent.rcv.r, 250)

default_depths(scn::Scenario) = range(calc_ocean_depth_range(scn)..., 150)