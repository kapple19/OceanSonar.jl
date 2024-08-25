export Environment

@kwdef mutable struct Environment <: OcnSon
    ocn::Medium{:ocean} = Ocean()
    sbd::Medium{:seabed} = Seabed()
    atm::Medium{:atmosphere} = Atmosphere("Standard")

    bty::Boundary{:bathymetry} = Bathymetry()
    ati::Boundary{:altimetry} = Altimetry("Flat")
    
    model::String = ""
end

function Environment(::Val{:munk_profile})
    env = Environment()
    env.model = "Munk Profile"
    env.ocn = Ocean("Munk")
    env.sbd = Seabed("Jensen Sand")
    env.bty = Bathymetry("Canonical Deep")
    return env
end

function Environment(::Val{:index_squared_profile})
    env = Environment()
    env.model = "Index-Squared Profile"
    env.ocn = Ocean("Index-Squared")
    env.sbd = Seabed("Jensen Sand")
    env.bty = Bathymetry("Mesopelagic")
    return env
end

function Environment(::Val{:parabolic_bathymetry})
    env = Environment()
    env.model = "Parabolic Bathymetry"
    env.ocn = Ocean("Homogeneous")
    env.sbd = Seabed("Jensen Sand")
    env.bty = Bathymetry("Parabolic")
    return env
end

@add_model_conversion_methods Environment