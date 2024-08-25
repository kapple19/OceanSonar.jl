export Slice

"""
TODO.
"""
@kwdef mutable struct Slice <: Container
    model::Val = Val(Symbol())

    atm::Atmosphere = Atmosphere()
    ocn::Ocean = Ocean()
    sbd::Seabed = Seabed()

    ati::Altimetry = Altimetry()
    bty::Bathymetry = Bathymetry()
end

Slice(model::Val{:lloyd_mirror}) = Slice(
    model = model,
    ocn = Ocean(:homogeneous),
    sbd = Seabed(:jensen_clay),
    bty = Bathymetry(:half_kilometre)
)

Slice(model::Val{:munk_profile}) = Slice(
    model = model,
    ocn = Ocean(:munk_profile),
    sbd = Seabed(:jensen_clay),
    bty = Bathymetry(:deep)
)

Slice(model::Val{:index_squared_profile}) = Slice(
    model = model,
    ocn = Ocean(:index_squared_profile),
    sbd = Seabed(:jensen_clay),
    bty = Bathymetry(:mesopelagic)
)

Slice(model::Val{:parabolic_bathymetry}) = Slice(
    model = model,
    ocn = Ocean(:homogeneous),
    sbd = Seabed(:jensen_basalt),
    bty = Bathymetry(:parabolic)
)

Slice(model::Val{:linearised_convergence_zones}) = Slice(
    model = model,
    ocn = Ocean(:linearised_convergence_zones),
    sbd = Seabed(:jensen_basalt),
    bty = Bathymetry(:deep)
)

Slice(model::Val{:norwegian_sea}) = Slice(
    model = model,
    ocn = Ocean(:norwegian_sea),
    sbd = Seabed(:jensen_basalt),
    bty = Bathymetry(:four_kilometers)
)

@parse_models Slice