function interactive_raycurves(
    cel::Function, bty::Function, ati::Function;
    r_min::Real = 0.0, r_max::Real,
    z_min::Real = ati(r_min), z_max::Real = bty(r_min),
    z_src::Real = [z_min, z_max] |> mean,
    num_rays::Integer, min_angle::Real, max_angle::Real,
)
    r_min = 0.0

    @assert ati(0) isa Real
    @assert bty(0) isa Real
    @assert cel(0, 0) isa Real

    fig = Figure()
    axis = Axis(fig[1, 1],
        yreversed = true,
        xlabel = "Range [m]",
        ylabel = "Depth [m]"
    )

    source_depth_slider = Slider(fig[1, 0],
        range = range([ati(r_min), bty(r_min)]..., 31),
        horizontal = false,
        startvalue = z_src
    )

    fan = lift(source_depth_slider.value) do z₀
        Fan("Gaussian",
            range(min_angle, max_angle, num_rays),
            z₀, r_max, 1e3,
            cel,
            bty, ReflectionCoefficientProfile("Reflective"),
            ati, ReflectionCoefficientProfile("Mirror")
        )
    end

    r_ntv = interval(r_min, r_max)
    z_min = ati(r_ntv) |> inf
    z_max = bty(r_ntv) |> sup

    celerityheatmap!(axis, cel, r_min, r_max, z_min, z_max)
    altimetryband!(axis, ati, r_min, r_max)
    bathymetryband!(axis, bty, r_min, r_max)
    raycurves!(axis, fan)

    limits!(axis, r_min, r_max, z_min, z_max)

    return fig
end
