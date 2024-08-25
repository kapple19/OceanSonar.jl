reflection_angle_degrees(
    θ_bnd_deg::Real, θ_inc_deg::Real
) = mod(2θ_bnd_deg - θ_inc_deg + 180, 360) - 180

reflection_coefficient(::Val{:rayleigh},
    z_int::Complex, z_ext::Complex
) = 1.0