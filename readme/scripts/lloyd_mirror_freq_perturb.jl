using OceanSonar
using CairoMakie
using Statistics

model = "Lloyd Mirror"

function run_prop(f)
    scen = Scenario(model)
    scen.f = f
    return Propagation("Trace", scen)
end

props = [run_prop(f) for f in series125(5e3)]

bounds(data) = mean(data) .+ (3std(data) * [-1, 1])
clims = [prop.PL for prop in props] |> splat(vcat) |> bounds

fig = Figure()
num_rows, num_cols = OceanSonar.rect_or_square_gridsize(props |> length)
heatmaps = Makie.Plot[]
for row in 1:num_rows, col in 1:num_cols
    lin = LinearIndices((num_cols, num_rows))

    idx_prop = lin[col, row]
    prop = props[idx_prop]

    pos = fig[row, col]
    axis = Axis(pos,
        yreversed = true,
        title = string(prop.scen.f, " Hz")
    )
    hidedecorations!(axis)

    hm = heatmap!(axis,
        prop,
        colormap = Reverse(:jet),
        colorrange = clims,
        interpolate = true # https://github.com/MakieOrg/Makie.jl/issues/2514
    )
    push!(heatmaps, hm)
end
Colorbar(fig[:, end+1], heatmaps[1],
    label = OceanSonar.label(Propagation)
)
Label(fig[0, :], model,
    fontsize = 25
)

fig