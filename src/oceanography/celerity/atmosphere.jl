export atmosphere_celerity
export AtmosphereCelerity

"""
TODO.
"""
function atmosphere_celerity end

atmosphere_celerity(::Val{:standard}, x::Real, z::Real) = 343.0

@parse_models_w_args atmosphere_celerity

"""
TODO.
"""
struct AtmosphereCelerity <: Celerity
    model::Val
end

function (cel::AtmosphereCelerity)(x::Real, z::Real)
    atmosphere_celerity(cel.model, x, z)
end

@parse_models AtmosphereCelerity

AtmosphereCelerity() = AtmosphereCelerity(:standard)

list_model_symbols(::Type{AtmosphereCelerity}) = list_model_symbols(atmosphere_celerity)