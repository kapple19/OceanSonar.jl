export Propagation

abstract type Propagation <: OcnSon end

function MakieCore.convert_arguments(plot_type::MakieCore.GridBased, prop::Propagation)
    MakieCore.convert_arguments(plot_type, prop.x_vec, prop.z_vec, prop.PL)
end

include("propagation/ray.jl")