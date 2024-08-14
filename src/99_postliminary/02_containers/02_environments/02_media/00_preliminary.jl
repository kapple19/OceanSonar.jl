export Atmosphere
export Ocean
export Seabed

abstract type MediumType <: EnvironmentComponent end

struct AtmosphereMedium <: MediumType end
struct OceanMedium <: MediumType end
struct SeabedMedium <: MediumType end

mutable struct AcousticMedium{MT <: MediumType} <: ModellingContainer
    den::Function
    wnd::Function
    cel::Function
    shear_cel::Function
    atn::Function
    shear_atn::Function
end

Atmosphere = AcousticMedium{AtmosphereMedium}
Ocean = AcousticMedium{OceanMedium}
Seabed = AcousticMedium{SeabedMedium}

AcousticMedium{AtmosphereMedium}(;
    den::Function = AtmosphereDensityProfile(:Homogeneous),
    wnd::Function = @initialise_function,
    cel::Function = AtmosphereCelerityProfile(:Homogeneous),
    shear_cel::Function = @initialise_function,
    atn::Function = @initialise_function,
    shear_atn::Function = @initialise_function,
) = AcousticMedium{AtmosphereMedium}(den, wnd, cel, shear_cel, atn, shear_atn)

AcousticMedium{OceanMedium}(;
    den::Function = OceanDensityProfile(:Homogeneous),
    wnd::Function = @initialise_function,
    cel::Function = OceanCelerityProfile(:Munk),
    shear_cel::Function = @initialise_function,
    atn::Function = @initialise_function,
    shear_atn::Function = @initialise_function,
) = AcousticMedium{OceanMedium}(den, wnd, cel, shear_cel, atn, shear_atn)

AcousticMedium{SeabedMedium}(;
    den::Function = SeabedDensityProfile(:Homogeneous),
    wnd::Function = @initialise_function,
    cel::Function = SeabedCelerityProfile(:Homogeneous),
    shear_cel::Function = @initialise_function,
    atn::Function = @initialise_function,
    shear_atn::Function = @initialise_function,
) = AcousticMedium{SeabedMedium}(den, wnd, cel, shear_cel, atn, shear_atn)
