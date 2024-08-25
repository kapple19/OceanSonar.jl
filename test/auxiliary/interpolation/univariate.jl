using OceanSonar
using Test
using PropCheck

function wrap_check(prop::Function, gen::Integrated)
    chk = check(splat(prop), gen)
    chk isa Bool && return chk
    @info chk
    return prop(chk[1]...)
end

function constant_univariate(F_val, a)
    uni = Univariate(F_val)
    return uni(a) == F_val
end

@test wrap_check(constant_univariate, itype(NTuple{2, Float64}))