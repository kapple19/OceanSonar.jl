module LloydsMirror
function lloydsmirror_singlereflection(c, f, r_src, r_hyd, z_src, z_hyd)
	λ = c/f
	k = 2π/λ

	s_dir = sqrt((r_src - r_hyd)^2 + (z_src - z_hyd)^2)
	s_rfl = sqrt((r_src - r_hyd)^2 + (z_src + z_hyd)^2)

	pressure(s) = exp(im*k*s)/s
	p_dir = pressure(s_dir)
	p_rfl = -pressure(s_rfl)

	p = p_dir + p_rfl
	TL = -20log10(abs(p))
end
end