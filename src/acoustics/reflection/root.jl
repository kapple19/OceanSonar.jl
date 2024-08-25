export reflection_coefficient

reflection_angle_degrees(
    θ_bnd_deg::Real, θ_inc_deg::Real
) = mod(2θ_bnd_deg - θ_inc_deg + 180, 360) - 180

specific_impedance(ρ::Real, c::Number) = ρ * c

snells_law(c_inc::Number, θ_inc::Number, c_rfr::Number) = c_rfr / c_inc * cos(θ_inc) |> acos

function reflection_coefficient end

@parse_models_w_args reflection_coefficient

function reflection_coefficient(::Val{:rayleigh_fluid},
    ρ_inc::Real, ρ_rfr::Real, 
    c_inc::Number, c_rfr::Number, 
    α_inc::Number, α_rfr::Number, 
    θ_inc::Number
)
    ς_inc = complex_celerity(c_inc, α_inc)
    ς_rfr = complex_celerity(c_rfr, α_rfr)

    θ_rfr = snells_law(ς_inc, θ_inc, ς_rfr)

    𝓏_inc = specific_impedance(ρ_inc, ς_inc)
    𝓏_rfr = specific_impedance(ρ_rfr, ς_rfr)

    _rfr = 𝓏_rfr * sin(θ_inc)
    _inc = 𝓏_inc * sin(θ_rfr)

    return (_rfr - _inc) / (_rfr + _inc)
end

function reflection_coefficient(::Val{:rayleigh_solid},
    ρ_inc::Real, ρ_rfr::Real, 
    c_inc::Number, c_compr_rfr::Number, c_shear_rfr::Number, 
    α_inc::Number, α_compr_rfr::Number, α_shear_rfr::Number, 
    θ_inc::Number
)
    ς_inc = complex_celerity(c_inc, α_inc)
    ς_compr_rfr = complex_celerity(c_compr_rfr, α_compr_rfr)
    ς_shear_rfr = complex_celerity(c_shear_rfr, α_shear_rfr)

    θ_compr_rfr = snells_law(ς_inc, θ_inc, ς_compr_rfr)
    θ_shear_rfr = snells_law(ς_inc, θ_inc, ς_shear_rfr)

    𝓏_inc = specific_impedance(ρ_inc, ς_inc)
    𝓏_compr_rfr = specific_impedance(ρ_rfr, ς_compr_rfr)
    𝓏_shear_rfr = specific_impedance(ρ_rfr, ς_shear_rfr)

    sin_shear_rfr = sin(θ_shear_rfr)
    sin_compr_rfr = sin(θ_compr_rfr)

    _inc = 𝓏_inc * sin_compr_rfr * sin_shear_rfr
    _compr_rfr = 𝓏_compr_rfr * sin_shear_rfr * cos(2θ_shear_rfr)^2
    _shear_rfr = 𝓏_shear_rfr * sin_compr_rfr * sin(2θ_shear_rfr)^2
    _rfr = sin(θ_inc) * (_compr_rfr + _shear_rfr)

    return (_rfr - _inc) / (_rfr + _inc)
end

abstract type ReflectionCoefficient <: Functor end

include("surface.jl")
include("bottom.jl")