@userplot ScenarioPlot
@recipe function plot(sp::ScenarioPlot)
	# Inputs
	scn = sp.args[1]

	# Plot Design
	legend --> :none
	yflip := true
	
	# Extrema
	ocn_depth_range = calc_ocean_depth_range(scn)
	ex = (
		srf = minimum(ocn_depth_range),
		btm = maximum(ocn_depth_range)
	)
	ylims --> (ex.srf, ex.btm)

	# Plot Labels
	plot_title := scn.name
	xguide := "Range [m]"
	yguide := "Depth [m]"

	r = range(0.0, scn.ent.rcv.r)
	# Boundaries
	for boundary in (:srf, :btm)
		bnd = getproperty(scn.env, boundary)
		r = range(0.0, scn.ent.rcv.r)
		z = bnd.z.(r)
		@series begin
			linecolor := :brown
			fillrange := zeros(size(z)) .+ ex[boundary]
			fillcolor := :brown
			r, z
		end
	end
end

@userplot PropagationPlot
@recipe function plot(pp::PropagationPlot)
	fld = pp.args[1]

	legend --> :none
	yflip := true

	@series begin
		seriestype := :heatmap
		seriescolor := cgrad(:jet, rev = true)
		fld.r, fld.z, fld.PL'
	end

end