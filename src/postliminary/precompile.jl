@setup_workload begin
    scen = Scenario("Munk Profile")

    @compile_workload begin
        beam = Beam("Gaussian", scen, angle = 0.0)
        beams = Beams("Gaussian", scen)
        prop = Propagation("Trace", scen) # TODO: loop through `Propagation` models
    end
end