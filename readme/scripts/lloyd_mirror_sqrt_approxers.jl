using OceanSonar
using CairoMakie

scen = Scenario("Lloyd Mirror")
config = ParabolicConfig()
for model = list_models(RationalFunctionApproximation)
    # config.marcher = marcher
    # prop = Propagation(config, scen)
    # visual!(prop) # TODO: tile
end

nothing