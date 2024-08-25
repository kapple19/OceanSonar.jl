# struct BottomReflectionCoefficient <: ReflectionCoefficient
#     model::Val
# end

function BottomReflectionCoefficient(::Val{:rayleigh_solid}, slc::Slice)
    function func(x::Real, z::Real, f::Real, θ_inc::Real)
        reflection_coefficient(:rayleigh_solid,
            slc.ocn.den(x, z),
            slc.sbd.den(x, 0),
            slc.ocn.cel(x, z),
            slc.sbd.cel(x, 0),
            slc.sbd.shear_cel(x, 0),
            slc.ocn.atn(x, z, f),
            slc.sbd.atn(x, 0, f),
            slc.sbd.shear_atn(x, 0, f),
            θ_inc
        )
    end
end

@parse_models_w_args BottomReflectionCoefficient

# function list_models(::Type{BottomReflectionCoefficient})
#     list_models(reflection_coefficient)
# end