##
using OceanSonar, GLMakie

interactive_raycurves(
    OceanCelerityProfile("Munk"),
    BathymetryProfile("Flat", z = 5e3),
    AltimetryProfile("Flat");
    r_max = 100e3,
    num_rays = 5,
    min_angle = -π/20,
    max_angle = π/20
)

##
using OceanSonar, GLMakie

interactive_raycurves(
    OceanCelerityProfile("Homogeneous"),
    BathymetryProfile("Parabolic"),
    AltimetryProfile("Flat");
    r_max = 20e3,
    z_src = 0.0,
    num_rays = 5,
    min_angle = atan(5, 20),
    max_angle = atan(5, 2)
)
