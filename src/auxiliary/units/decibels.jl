export complex_celerity

decibels_per_wavelength_to_nepers(α::Real) = α  / (2π * 20log10(ℯ))

complex_celerity(c::Real, α::Real) = c * (1 - im * decibels_per_wavelength_to_nepers(α))

# [dB / m / kHz] = [dB / m / Hz] / 1000
# [dB / m / kHz] = [Np / m] * 1000 * 20log10(ℯ) / f
# [dB / m / Hz] / 1000 = [Np / m] * 1000 * 20log10(ℯ) / f
# [dB / m / Hz] = 10⁶ * [Np / m] * 20log10(ℯ) / f
# [dB / m] = [Np / m] * 20log10(ℯ)
# [dB / λ] = [Np / m] * λ * 20log10(ℯ)
# [dB / λ] = δ * 20log10(ℯ) * 2π