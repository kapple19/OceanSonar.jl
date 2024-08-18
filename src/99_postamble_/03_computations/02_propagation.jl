export Propagation

@kwdef struct Propagation
    model::Model{M} where {M} = Model{:Tracing}
    coherence::Model{C} where {C} = Model{:Coherent}

    surface::Interface = Interface(:Surface, :Flat)
    bottom::Interface = Interface(:Bottom, :Flat)

    # atmosphere::Medium
    ocean::Medium = Medium(:Ocean, :MunkSoundSpeed)
    # seabed::Medium

    z::Float64
end

function (prop::Propagation)(f::RealScalarOrArray, r::RealScalarOrArray, z::RealScalarOrArray, θ::RealScalarOrArray)
    return propagate(prop.model, f)
end
