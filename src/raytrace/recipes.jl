@userplot RayTracePlot
@recipe function plot(rtp::RayTracePlot)
	# Parse Inputs
	trc = rtp.args[1]

	# Plot Design.
	legend --> :none

	yflip := true

	rays = if length(rtp.args) == 2
		Nrays = length(trc.rays)
		opt = rtp.args[2]
		if opt isa Integer
			if opt > Nrays
				error("Requesting to plot more rays than available.")
			end
			idxs = range(1, Nrays, opt) .|> round .|> Int |> unique!
			trc.rays[idxs]

		elseif opt == :series125
			error("Not implemented yet.")
		elseif opt == :series125mirror
			error("Not implemented yet.")
		elseif opt == :boundaries
			error("Not implemented yet.")
		elseif opt == :waveguides
			error("Not implemented yet.")
		elseif opt == :angle
			error("Not implemented yet.")
		elseif opt == :anglesign
			error("Not implemented yet.")
		else
			error("Unknown ray trace plot option.")
		end
	else
		trc.rays
	end
	
	# Ray Trace
	for ray in rays
		s = range(0.0, ray.s_max, 501)
		r = ray.r.(s)
		z = ray.z.(s)
		@series r, z
	end
end