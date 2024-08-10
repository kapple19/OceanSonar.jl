@setup_workload begin
    cel = OceanCelerityProfile("Munk")
    bty = BathymetryProfile("Flat", z = 5e3)
    Rbot = ReflectionCoefficientProfile("Reflective")
    ati = AltimetryProfile("Flat")
    Rsrf = ReflectionCoefficientProfile("Mirror")

    @compile_workload begin
        fan = Fan(
            "Gaussian",
            π/20 * range(-1, 1, 3),
            1e3, 100e3, 1e3,
            cel,
            bty,
            Rbot,
            ati,
            Rsrf
        )
    end
end