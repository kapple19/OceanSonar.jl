module Examples
using ..OACBase

north_atlantic_convergence_zones = let
	env_north_atlantic = let
		ocn = Ocean(
			[0, 300, 1200, 2e3, 5e3],
			[1522, 1501, 1514, 1496, 1545.0]
		)

		Environment(ocn, (5e3, 0.0), (0, -1))
	end

		Scenario(
		env_north_atlantic,
		((200, 0), 250e3),
		"North Atlantic Convergence Zones"
	)
end

munk_profile = let
	f = 5e2
	z_src = 1e3

	z̃(z) = 2/1300*(z - 1300)
	ϵ = 7.37e-3
	c(r, z) = 1500(1 + ϵ*(z̃(z) - 1 + exp(-z̃(z))))

	scn = Scenario(
		(c, (5e3, 0.0), (0.0, 0.0)),
		((f, z_src), 100e3),
		"Munk Profile"
	)
end

n2_linear_profile = let
	c₀ = 1550.0
	c(r, z) = c₀ / √(max(0.0, 1 + 2.4z / c₀))

	ocn = Ocean(c)

	scn = Scenario(
		(ocn, (1e3, 1.0), (0.0, 0.0)),
		((2e3, 1e3), 10e3),
		"n²-Linear Profile"
	)
end

parabolic_bathymetry = let
	r_rcv = 20e3

	c = 250.0
	b = 2.5e5
	z_bty(r) = 2e-3b * √(1 + r/c)

	scn = Scenario(
		(c, (z_bty, 1.0), (0.0, 0.0)),
		((2e2, 0.0), r_rcv),
		"Parabolic Bathymetry"
	)
end

lloyd_mirror = let
	scn = Scenario(
		(1500, (500, 0.0)),
		((150, 25), 500),
		"Lloyd Mirror"
	)
end

export_all(@__MODULE__)
end # module Examples

examples = get_names(Examples)
export Examples
export examples