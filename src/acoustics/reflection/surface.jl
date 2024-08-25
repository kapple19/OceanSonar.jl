function SurfaceReflectionCoefficient(::Val{:rayleigh_fluid}, slc::Slice)
    function func(x::Real, z::Real, f::Real, θ_inc::Real)
        reflection_coefficient(:rayleigh_fluid,
            slc.ocn.den(x, z),
            slc.atm.den(x, z),
            slc.ocn.cel(x, z),
            slc.atm.cel(x, z),
            slc.ocn.atn(x, z, f),
            slc.atm.atn(x, z, f),
            θ_inc
        )
    end
end

@parse_models_w_args SurfaceReflectionCoefficient

# function list_models(::Type{SurfaceReflectionCoefficient})
#     list_models(reflection_coefficient)
# end