dot(u::AbstractVector{<:Number}, v::AbstractVector{<:Number}) = u' * v

function gradient2tangent(m::Float64)
	x = 1 / √(m^2 + 1)
	[x; m*x]
end

function reflection(tng_inc::Vector{Float64}, m_bnd::Real)
	m_bnd = Float64(m_bnd)
	tng_bnd = gradient2tangent(m_bnd)
	nrm_bnd = [0 1; -1 0] * tng_bnd
	α = dot(tng_inc, nrm_bnd) # [Jensen et al. eq. 3.118]
	tng_rfl = tng_inc - 2α * nrm_bnd # [Jensen et al. eq. 3.121]
	atan(tng_rfl[2] / tng_rfl[1])
end