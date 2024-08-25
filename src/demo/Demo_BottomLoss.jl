
using Plots; pyplot()

include("../OceanParameters.jl")

## Replicate Bottom Loss Curves

θ₁ = π/4
@show BL = OceanParameters.bottom_loss(θ₁)

l = @layout [a b; c d]
θ₁ = deg2rad.(range(0, 90, length = 100))

cₚ = [1550. 1600. 1800.]
Numθ₁ = length(θ₁)
Numcₚ = length(cₚ)
BL = zeros(AbstractFloat, (Numθ₁, Numcₚ))
for nθ₁ = 1:length(θ₁)
	for ncₚ = 1:length(cₚ)
		BL[nθ₁, ncₚ] = OceanParameters.bottom_loss(θ₁[nθ₁]; cₚ = cₚ[ncₚ])
	end
end

p1 = plot(rad2deg.(θ₁), BL,
	xaxis = 0:30:90,
	yaxis = ("Loss (dB)", 0:5:15),
	label = cₚ,
	legendtitle = "cₚ (m/s)",
	legend = :bottomright)

αₚ = [1. 0.5 0]
Numθ₁ = length(θ₁)
Numαₚ = length(αₚ)
BL = zeros(AbstractFloat, (Numθ₁, Numαₚ))
for nθ₁ = 1:length(θ₁)
	for nαₚ = 1:length(αₚ)
		BL[nθ₁, nαₚ] = OceanParameters.bottom_loss(θ₁[nθ₁]; αₚ = αₚ[nαₚ])
	end
end

p2 = plot(rad2deg.(θ₁), BL,
	xaxis = 0:30:90,
	yaxis = 0:5:15,
	label = αₚ,
	legendtitle = "αₚ (dB/λ)",
	legend = :bottomright)

ρ₂ = [1.5e3 2e3 2.5e3]
Numρ₂ = length(ρ₂)
BL = zeros(AbstractFloat, (Numθ₁, Numρ₂))
for nθ₁ = 1:length(θ₁)
	for nρ₂ = 1:length(ρ₂)
		BL[nθ₁, nρ₂] = OceanParameters.bottom_loss(θ₁[nθ₁]; ρ₂ = ρ₂[nρ₂])
	end
end

p3 = plot(rad2deg.(θ₁), BL,
	xaxis = ("Grazing angle θ₁ (deg)", 0:30:90),
	yaxis = ("Loss (dB)", 0:5:15),
	label = ρ₂,
	legendtitle = "ρ₂ (kg/m³)",
	legend = :bottomright)

cₛ = [6e2 4e2 2e2 0.0]
Numcₛ = length(cₛ)
BL = zeros(AbstractFloat, (Numθ₁, Numcₛ))
for nθ₁ = 1:length(θ₁)
	for ncₛ = 1:length(cₛ)
		BL[nθ₁, ncₛ] = OceanParameters.bottom_loss(θ₁[nθ₁]; cₛ = cₛ[ncₛ], αₚ = 0.)
	end
end

p4 = plot(rad2deg.(θ₁), BL,
	xaxis = ("Grazing angle θ₁ (deg)", 0:30:90),
	yaxis = 0:5:15,
	label = cₛ,
	legendtitle = "cₛ (m/s)",
	legend = :bottomright)

pt = plot(p1, p2, p3, p4,
	layout = l)

savefig(pt, "img/BottomLoss_Parameters.png")

## Bottom Loss Types
θ₁ = deg2rad.(range(0., 90., length = Int(1e3)))
BottomTypes = ["Clay" "Silt" "Sand" "Gravel" "Moraine" "Chalk" "Limestone" "Basalt"]
ρ₂ = [1.5e3 1.7e3 1.9e3 2e3 2.1e3 2.2e3 2.4e3 2.7e3]
cₚ = [1.5e3 1575 1650 1.8e3 1950 2.4e3 3e3 5250]
cₛ = [5e1 0 0 0 6e2 1e3 1.5e3 2.5e3]
αₚ = [0.2 1. 0.8 0.6 0.4 0.2 0.1 0.1]
αₛ = [1.0 1.5 2.5 1.5 1.0 0.5 0.2 0.2]

NumBot = length(BottomTypes)
Numθ = length(θ₁)
BL = zeros(AbstractFloat, (Numθ, NumBot))
for nBot = 1:NumBot
	for nθ = 1:Numθ
		BL[nθ, nBot] = OceanParameters.bottom_loss(θ₁[nθ]; cₚ = cₚ[nBot], αₚ = αₚ[nBot], ρ₂ = ρ₂[nBot], cₛ = cₛ[nBot], αₛ = αₛ[nBot])
	end
end

pt = plot(rad2deg.(θ₁), BL,
	title = "Bottom Loss Types",
	yaxis = ("Bottom Reflection Loss (dB)", 0:5:20),
	xaxis = ("Grazing Angle (deg)", 0:15:90),
	label = BottomTypes,
	ylims = (0, 20))

savefig(pt, "img/BottomLoss_Types.png")

##
