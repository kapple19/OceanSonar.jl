function convert_arguments(plot::GridBased,
    modelling_functor::OceanSonar.ModellingFunctor,
    r::AbstractVector{<:Real},
    z::AbstractVector{<:Real}
)
    convert_arguments(plot, r, z,
        [
            modelling_functor(r̂, ẑ)
            for r̂ in r, ẑ in z
        ]
    )
end
