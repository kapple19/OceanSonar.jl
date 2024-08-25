export Environment

"""
TODO.
"""
@kwdef mutable struct Environment <: OcnSonContainer
    model::Val = Val(Symbol())

    atm::Atmosphere = Atmosphere()
    ocn::Ocean = Ocean()
    sbd::Seabed = Seabed()

    ati::Altimetry = Altimetry()
    bty::Bathymetry = Bathymetry()
end

Environment(model::Val{:munk_profile}) = Environment(
    model = model,
    ocn = Ocean(:munk_profile |> Val),
    sbd = Seabed(:jensen_gravel |> Val),
    bty = Bathymetry(:deep |> Val)
)

Environment(model::Val{:index_squared_profile}) = Environment(
    model = model,
    ocn = Ocean(:index_squared_profile |> Val),
    sbd = Seabed(:jensen_gravel |> Val),
    bty = Bathymetry(:mesopelagic |> Val)
)

Environment(model::Val{:parabolic_bathymetry}) = Environment(
    model = model,
    ocn = Ocean(:homogeneous |> Val),
    sbd = Seabed(:jensen_gravel |> Val),
    bty = Bathymetry(:parabolic |> Val)
)

@parse_models Environment