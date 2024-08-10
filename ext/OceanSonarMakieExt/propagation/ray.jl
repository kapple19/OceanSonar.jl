@recipe(RayCurves, fan) do scene
    Theme()
end

function convert_arguments(PlotType::Type{<:Series}, beams::AbstractVector{Beam})
    convert_arguments(PlotType,
        [
            [
                Point2(beam.r(s), beam.z(s))
                for s in range(0, beam.s_max, 301)
            ] for beam in beams
        ]
    )
end

function convert_arguments(PlotType::Type{<:Series}, fan::Fan)
    convert_arguments(PlotType, fan.beams)
end

function convert_arguments(PlotType::Type{<:Series}, beam::Beam)
    convert_arguments(PlotType, [beam])
end

function plot!(plot::RayCurves{<:Tuple{<:Fan}})
    series!(plot, plot.fan[], solid_color = :black)
end
