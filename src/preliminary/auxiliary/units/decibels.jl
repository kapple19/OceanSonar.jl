export complex_celerity
export db2pow
export pow2db
export ⊕

decibels_per_wavelength_to_nepers(α::Real) = α  / (2π * 20log10(ℯ))

complex_celerity(c::Real, α::Real) = c * (1 - im * decibels_per_wavelength_to_nepers(α))

# [dB / m / kHz] = [dB / m / Hz] / 1000
# [dB / m / kHz] = [Np / m] * 1000 * 20log10(ℯ) / f
# [dB / m / Hz] / 1000 = [Np / m] * 1000 * 20log10(ℯ) / f
# [dB / m / Hz] = 10⁶ * [Np / m] * 20log10(ℯ) / f
# [dB / m] = [Np / m] * 20log10(ℯ)
# [dB / λ] = [Np / m] * λ * 20log10(ℯ)
# [dB / λ] = δ * 20log10(ℯ) * 2π

db2pow(L) = 10^(L/10)
pow2db(P) = 10log10(P)
⊕(args...) = args .|> db2pow |> sum |> pow2db