##
using OceanSonar
using GLMakie

angles = [(θ₀ = 0, φ₀ = φ₀) for φ₀ in π/20 * range(-1, 1, 21)]
src_pos = (x₀ = -100.0, y₀ = 25.0, z₀ = 1e3)
beams = beam_ensemble(sound_speed_profile, src_pos, angles)

fig = Figure()

azimuth_view_slider = Slider(fig[1, 1],
    horizontal = true,
    range = 0:360,
    startvalue = 350
)

azimuth_view = lift(θview -> deg2rad(θview), azimuth_view_slider.value)

axis = Axis3(fig[2, 1],
    zreversed = true,
    azimuth = azimuth_view,
    viewmode = :fit,
    xlabel = "x [km]",
    ylabel = "y [km]",
    zlabel = "z [m]",
    title = "Rays Launched at the Same Azimuth"
)

curves = [
    [
        Point3(beam.x(s) * 1e-3, beam.y(s) * 1e-3, beam.z(s))
        for s in range(0, beam.s_max, 301)
    ] for beam in beams
]

series!(axis, curves, solid_color = :black)

display(fig)
