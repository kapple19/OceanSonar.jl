function visual!(::Model{:SoundSpeed2D},
    axis::AbstractAxis,
    z::AbstractVector{<:Real},
    c::AbstractVector{<:Real};
    kws...
)
    soundspeedlines2d!(axis, z, c; kws...)
end

function visual!(model::Model{:SoundSpeed2D},
    axis::AbstractAxis,
    z::AbstractVector{<:Real},
    c::Function;
    kws...
)
    visual!(model, axis, z, z .|> c; kws...)
end

function visual!(model::Model{:SoundSpeed2D},
    axis::AbstractAxis,
    z_min::Real,
    z_max::Real,
    c::Function;
    kws...
)
    z = range(z_min, z_max, 351)
    visual!(model, axis, z, z .|> c; kws...)
end

function visual!(model::Model{:SoundSpeed2D}, args...; kws...)
    visual!(model, current_axis(), args...; kws...)
end

function visual(model::Model{:SoundSpeed2D}, args...; kws...)
    fig = Figure()
    axis = OceanAxis2D(fig[1, 1])
    plot = visual!(model, axis, args...; kws...)

    return FigureAxisPlot(fig, axis, plot)
end
