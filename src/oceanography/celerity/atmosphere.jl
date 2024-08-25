export atmosphere_celerity
export AtmosphereCelerity

"""
TODO.
"""
function atmosphere_celerity end

atmosphere_celerity(::Val{:standard}, x::Real, z::Real) = 343.0

@parse_models_and_arguments atmosphere_celerity

"""
TODO.
"""
struct AtmosphereCelerity <: OcnSonFunctor
    model::Val

    AtmosphereCelerity(model::Val = Val(:standard)) = new(model)
end

(cel::AtmosphereCelerity)(x::Real, z::Real; kwargs...) = atmosphere_celerity(cel.model, x, z; kwargs...)

list_models(::Type{AtmosphereCelerity}) = list_models(atmosphere_celerity)