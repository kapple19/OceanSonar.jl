# struct BottomReflectionCoefficient <: ReflectionCoefficient
#     model::Val
# end

function BottomReflectionCoefficient(::Val{:rayleigh_solid}, env::Environment)
    function func(x::Real, z::Real, f::Real, θ_inc::Real)
        reflection_coefficient(:rayleigh_solid,
            env.ocn.den(x, z),
            env.sbd.den(x, 0),
            env.ocn.cel(x, z),
            env.sbd.cel(x, 0),
            env.sbd.shear_cel(x, 0),
            env.ocn.atn(x, z, f),
            env.sbd.atn(x, 0, f),
            env.sbd.shear_atn(x, 0, f),
            θ_inc
        )
    end
end

@parse_models_w_args BottomReflectionCoefficient

# function list_models(::Type{BottomReflectionCoefficient})
#     list_models(reflection_coefficient)
# end