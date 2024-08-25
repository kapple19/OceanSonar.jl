@testset "Scenario" for scenario in examples
	scn = getproperty(Examples, scenario)
	sp = scenarioplot(scn)
	savefig(sp, joinpath("img", "scenario", "scenario_" * string(scenario) * ".png"))

	@test scn isa Scenario
end