export atmosphere_celerity
export AtmosphereCelerity

atmosphere_celerity(::Val{:standard}, ::Real, ::Real) = 343.0

@add_model_conversion_methods atmosphere_celerity

AtmosphereCelerity() = Celerity{:atmosphere}()
AtmosphereCelerity(model) = Celerity{:atmosphere}(model)

function (cel::Celerity{:atmosphere})(args...; kwargs...)
    atmosphere_celerity(cel.model, args...; kwargs...)
end