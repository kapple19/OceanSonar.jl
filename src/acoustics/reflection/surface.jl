function SurfaceReflectionCoefficient(::Val{:rayleigh_fluid}, env::Environment)
    function func(x::Real, z::Real, f::Real, θ_inc::Real)
        reflection_coefficient(:rayleigh_fluid,
            env.ocn.den(x, z),
            env.atm.den(x, z),
            env.ocn.cel(x, z),
            env.atm.cel(x, z),
            env.ocn.atn(x, z, f),
            env.atm.atn(x, z, f),
            θ_inc
        )
    end
end

@parse_models_w_args SurfaceReflectionCoefficient

# function list_models(::Type{SurfaceReflectionCoefficient})
#     list_models(reflection_coefficient)
# end