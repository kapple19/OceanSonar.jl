@recipe(SoundSpeedLines2D, z, c) do scene
    Theme()
end

function plot!(plot::SoundSpeedLines2D)
    lines!(plot, plot.c, plot.z)
    return plot
end
