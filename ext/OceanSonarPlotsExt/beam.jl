@recipe _(beam::Beam) = (([beam]),)

# TODO:
# * Make more efficient
# * Truncate to x-limits
@recipe function _(beams::Vector{Beam})
    legend --> :none
    yflip --> true
    color --> :black

    x = [
        beam.x.(
            [
                range(0, beam.s_max, 301); beam.s_rfl; beam.s_hrz
            ] |> OceanSonar.uniquesort!
        ) for beam in beams
    ]

    z = [
        beam.z.(
            [
                range(0, beam.s_max, 301); beam.s_rfl; beam.s_hrz
            ] |> OceanSonar.uniquesort!
        ) for beam in beams
    ]

    ((x, z),)
end

visual!(beam::Beam; kw...) = plot!(beam; kw...)

visual!(beams::Vector{Beam}; kw...) = plot!(beams; kw...)