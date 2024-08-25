##
using OceanAcoustics

for scenario in propertynames(examples)
	scn = getproperty(examples, scenario)
	println("="^(4*length(scenario |> string)))
	println(scn.name)

	trc = RayMethodField(scn,
	11,
	save_field = false,
	save_trace = true
	)
	@show trc
end

## Just One
using OceanAcoustics

scenario = :n2_linear_profile
scn = getproperty(examples, scenario)
trc = RayMethodField(scn,
	11,
	save_field = false,
	save_trace = true
)
for ray in trc.rays
	@show ray.s_max
end

##
using OceanAcoustics

scenario = :n2_linear_profile
scn = getproperty(examples, scenario)
fld, trc = RayMethodField(scn, [-π/4], save_trace = true)
ray = trc.rays[1]
s = range(0.0, ray.s_max, 101)
ray.τ.(s)
