using Plots

include("../SonarEquations.jl")

## ROC: Gaussian
PFA = 10.0.^range(-4, 1, length = 101)
d_dB = [0 3 6 9 10 12 15 20]
d = 10.0.^(d_dB/10)
POD = 100SonarEquations.probability_of_detection_gaussian.(d, PFA/100)

pt = plot(PFA, POD, label = d_dB,
	xaxis = ("PFA (%)", :log10),
	yaxis = "POD (%)",
	title = "ROC: Gaussian")
display(pt)

savefig(pt, "img/DetectionIndex_Gaussian.png")

## ROC: Exponential
PFA = 10.0.^range(-4, 1, length = 101)
d_dB = [0 3 6 9 10 12 15 20 30]
d = 10.0.^(d_dB/10)
POD = 100SonarEquations.probability_of_detection_exponential.(d, PFA/100)

pt = plot(PFA, POD, label = d_dB,
	xaxis = ("PFA (%)", :log10),
	yaxis = "POD (%)",
	title = "ROC: Exponential")
display(pt)

savefig(pt, "img/DetectionIndex_Exponential.png")

## ROC: Rayleigh
PFA = 10.0.^range(-4, 1, length = 101)
d_dB = [0 3 6 9 10 12 15 20 30]
d = 10.0.^(d_dB/10)
POD = 100SonarEquations.probability_of_detection_rayleigh.(d, PFA/100)

pt = plot(PFA, POD, label = d_dB,
	xaxis = ("PFA (%)", :log10),
	yaxis = "POD (%)",
	title = "ROC: Rayleigh")
display(pt)

savefig(pt, "img/DetectionIndex_Rayleigh.png")