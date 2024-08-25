export field_starter
export FieldStarter

function field_starter(::Val{:gaussian}, k₀::Real, z₀::Real, z::Real)
    return √(k₀) * exp(
        (-k₀ * (z - z₀))^2 / 2
    )
end

function field_starter(::Val{:green}, k₀::Real, z₀::Real, z::Real)
    k₀² = k₀^2
    return √(k₀) * (
        1.4467 - 0.4201k₀² * (z - z₀)^2
    ) * exp(
        -k₀² * (z - z₀) / 3.0512
    )
end

@parse_models_w_args field_starter

struct FieldStarter <: Univariate
    model::Val
    k₀::Real
    z₀::Real

    function FieldStarter(model::Val, scen::Scenario)
        k₀ = 2π * scen.f / scen.env.ocn.cel(0, scen.z)
        
        new(model, k₀, scen.z)
    end
end

function (starter::FieldStarter)(z::Real)
    field_starter(starter.model, starter.k₀, starter.z₀, z)
end

@parse_models_w_args FieldStarter