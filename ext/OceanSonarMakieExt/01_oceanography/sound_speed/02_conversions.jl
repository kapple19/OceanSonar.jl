# I don't understand why this doesn't fucking work.
# function convert_arguments(
#     PlotType::Type{<:SoundSpeedLines2D},
#     z::AbstractVector{<:Real},
#     c::Function
# )
#     @info 1
#     return (z, z .|> c)
# end

# function convert_arguments(
#     PlotType::Type{<:SoundSpeedLines2D},
#     z_min::Real,
#     z_max::Real,
#     c::Function
# )
#     @info 2
#     convert_arguments(PlotType, range(z_min, z_max, 351), c)
# end
