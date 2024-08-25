module OceanParameters
"""
	bottom_loss
"""
function bottom_loss(θ₁;
	f = 1e3,
	c₁ = 1.5e3, α₁ = 0, ρ₁ = 1e3,
	cₚ = 1.6e3, cₛ = 0., αₚ = 0.5, αₛ = 0., ρ₂ = 2e3)
	# Functions
	Wavelength(c, f) = c/f
	Wavenumber(λ) = 2π/λ
	# Wavenumber(c, f) = Wavenumber(Wavelength(c, f))
	ComplexInv(val) = val == 0 ? Inf : 1/val
	Wavenumber(c, f) = 2π*f*ComplexInv(c)
	invcos(z) = π/2 + im*log(im*z + sqrt(1 - z^2))
	LossTangent(α_dbpwl) = α_dbpwl/(40π*log10(ℯ))
	ComplexSoundSpeed(cᵣ, δ) = cᵣ/(1 - im*δ)

	# Water
	δ₁ = LossTangent(α₁)
	ς₁ = ComplexSoundSpeed(c₁, δ₁)
	λ₁ = Wavelength(ς₁, f)
	k₁ = Wavenumber(ς₁, f)

	# Sediment: Compressional
	δₚ = LossTangent(αₚ)
	ςₚ = ComplexSoundSpeed(cₚ, δₚ)
	λₚ = Wavelength(ςₚ, f)
	kₚ = Wavenumber(ςₚ, f)

	# Sediment: Shear
	δₛ = LossTangent(αₛ)
	ςₛ = ComplexSoundSpeed(cₛ, δₛ)
	λₛ = Wavelength(ςₛ, f)
	kₛ = Wavenumber(ςₛ, f)

	# Bottom Loss
	kcosθ₁ = k₁*cos(θ₁)
	θₚ = invcos(Complex(kcosθ₁/kₚ))
	θₛ = invcos(Complex(kcosθ₁/kₛ))
	𝒵₁ = ρ₁*ς₁/sin(θ₁)
	𝒵ₚ = ρ₂*ςₚ/sin(θₚ)
	𝒵ₛ = ρ₂*ςₛ/sin(θₛ)
	𝒵_tot = 𝒵ₚ*cos(2θₛ)^2 + 𝒵ₛ*sin(2θₛ)^2
	ℛ = (𝒵_tot - 𝒵₁)/(𝒵_tot + 𝒵₁)
	BL = -10log10(abs(ℛ)^2)

	return BL
end

# struct Sonar

# end

# struct Medium

# end

# struct Fluid

# end

# struct Solid
# 	cₚ::Real
# 	cₛ::Real
# 	αₚ::Real
# 	αₛ::Real
# 	ρ₂::Real
# end

# function bottom_loss(θ₁, Sig::Sonar, Ocn::Fluid, Sed::Solid)
# 	# Signal
# 	f = Sig.f
	
# 	# Ocean
# 	c₁ = Ocn.c
# 	α₁ = Ocn.α
# 	ρ₁ = Ocn.ρ

# 	# Sediment
# 	cₚ = Sed.cₚ
# 	cₛ = Sed.cₛ
# 	αₚ = Sed.αₚ
# 	αₛ = Sed.αₛ
# 	ρ₂ = Sed.ρ

# 	BL = bottom_loss(θ₁;
# 	f,
# 	c₁, α₁, ρ₁,
# 	cₚ, cₛ, αₚ, αₛ, ρ₂)
# end

end