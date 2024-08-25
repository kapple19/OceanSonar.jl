function propagation_loss(p::Complex)
	PL = 20log10(p |> abs)
end

function total_noise_level(NL_ambient::Real, NL_ownship::Real)
	NL = (NL_ambient ⊕ NL_ownship)
end

function directivity_index(n::Integer, f::Real, γ_window::Real, f_design::Real)
	DI = 10log10(n * f / γ_window / f_design)
end

function signal_to_noise_ratio_passive_intercept(SL::Real, PL::Real, NL::Real, DI::Real)
	SNR = SL - PL - NL + DI
end

function signal_to_noise_ratio_active(SL::Real, PL::Real, TS::Real, NL::Real, RL::Real, DI::Real)
	SNR = SL - 2PL + TS - (NL ⊕ RL) + DI
end

function signal_to_noise_ratio_bistatic(SL::Real, PL1::Real, TS::Real, PL2::Real, NL::Real, RL::Real, DI::Real)
	SNR = SL - PL1 + TS - PL2 - (NL ⊕ RL) + DI
end