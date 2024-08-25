@testset "Literature Replications" begin
	img_dir = joinpath("img", "raytrace", "literature")

	@info "Jensen et al, Fig 3.16"
	@test begin
		scn = getproperty(Examples, :n2_linear_profile)
		fld = RayTrace.Field(scn, [-π/4])
		fld.PL = max.(40, fld.PL)
		fld.PL = min.(90, fld.PL)

		fig = propagationplot(fld)
		scenarioplot!(scn)
		savefig(fig,
			joinpath(img_dir, "jensenetal2011_fig_3_16.png")
		)

		fld isa Field
	end

	@info "Jensen et al, Fig 3.24"
	@test begin
		scn = getproperty(Examples, :parabolic_bathymetry)
		θ_lo = atan(3.3/20)
		θ_hi = atan(5/2)
		fld = RayTrace.Field(scn, range(θ_lo, θ_hi, 101))
		fld.PL = max.(65, fld.PL)
		fld.PL = min.(80, fld.PL)

		fig = propagationplot(fld)
		scenarioplot!(scn)
		savefig(fig,
			joinpath(img_dir, "jensenetal2011_fig_3_24.png")
		)

		fld isa Field
	end

	@info "Jensen et al, Fig 3.32b"
	@test begin
		scn = getproperty(Examples, :munk_profile)
		trc = RayTrace.Field(scn, atan(1/5) * range(-1, 1, 40), save_field = false, save_trace = true)

		fig = raytraceplot(trc)
		scenarioplot!(scn)
		savefig(fig,
			joinpath(img_dir, "jensenetal2011_fig_3_32b.png")
		)

		trc isa Trace
	end

	@info "Jensen et al, Fig 3.33"
	@test begin
		scn = getproperty(Examples, :munk_profile)
		fld = RayTrace.Field(scn, atan(1/4) * range(-1, 1, 101))
		fld.PL = max.(65, fld.PL)
		fld.PL = min.(80, fld.PL)

		fig = propagationplot(fld)
		scenarioplot!(scn)
		savefig(fig,
			joinpath(img_dir, "jensenetal2011_fig_3_33.png")
		)

		fld isa Field
	end
end