export Scenario

@kwdef mutable struct Scenario <: OcnSon
    x::Float64
    z::Float64
    f::Float64
    env::Environment = Environment()
    model::String = ""
end

function Scenario(model::Val{:munk_profile})
    Scenario(
        model = "Munk Profile",
        env = Environment(model),
        x = 100e3,
        z = 1e3,
        f = 1e3
    )
end

function Scenario(model::Val{:index_squared_profile})
    Scenario(
        model = "Index-Squared Profile",
        env = Environment(model),
        x = 3.5e3,
        z = 1e3,
        f = 1e3
    )
end

function Scenario(model::Val{:parabolic_bathymetry})
    Scenario(
        model = "Parabolic Bathymetry",
        env = Environment(model),
        x = 20e3,
        z = 0.0,
        f = 1e3
    )
end

@add_model_conversion_methods Scenario