module MakieCoreExt

using OceanSonar
using MakieCore

function MakieCore.convert_arguments(plot_type::MakieCore.PointBased, beam::Beam)
    s_vec = range(0, beam.s_max, 301)
    MakieCore.convert_arguments(plot_type, beam.x.(s_vec), beam.z.(s_vec))
end

function MakieCore.convert_arguments(::MakieCore.GridBased, prop::Propagation)
    prop.x, prop.z, prop.PL
end

function MakieCore.convert_arguments(::MakieCore.PointBased, prop::Propagation)
    (prop.beams, )
end

end