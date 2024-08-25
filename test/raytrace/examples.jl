@testset "Examples on Ray Trace Method" for scenario in examples
	img_dir = joinpath("img", "raytrace", "examples")

	scn = getproperty(Examples, scenario)
	@info "Ray Trace Method: $(scn.name)"

	fld, trc = RayTrace.Field(scn,
		save_field = true,
		save_trace = true
	)

	@test fld isa Field
	@test trc isa Trace

	@test fld.r isa AbstractVector{<:AbstractFloat}
	@test fld.z isa AbstractVector{<:AbstractFloat}
	@test fld.PL isa AbstractMatrix{<:AbstractFloat}

	rtp = raytraceplot(trc, 21)
	scenarioplot!(scn)
	savefig(rtp,
		joinpath(img_dir, "trace_" * string(scenario) * ".png")
	)

	fig = propagationplot(fld)
	scenarioplot!(scn)
	savefig(fig,
		joinpath(img_dir, "proploss_" * string(scenario) * ".png")
	)
end