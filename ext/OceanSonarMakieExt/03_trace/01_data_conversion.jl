function convert_arguments(plot::Type{<:Series}, beams::AbstractVector{Beam})
    convert_arguments(plot,
        [
            [
                Point2(beam.r(s), beam.z(s))
                for s in range(0, beam.s_max, 301)
            ] for beam in beams
        ]
    )
end

function convert_arguments(plot::Type{<:Series}, fan::Fan)
    convert_arguments(plot, fan.beams)
end

function convert_arguments(plot::Type{<:Series}, beam::Beam)
    convert_arguments(plot, [beam])
end
