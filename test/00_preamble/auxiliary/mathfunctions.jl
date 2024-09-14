using OceanSonar
using Test
using Supposition
using Supposition.Data:
    Floats,
    Satisfying,
    Vectors

floats = Floats{Float64}(; nans = true, infs = true)
intervals = Satisfying(
    Vectors(
        Floats(nans = false, infs = true);
        min_size = 2,
        max_size = 2
    ),
    issorted
)

@testset "$name" for name in names(OceanSonar.MathFunctions)
    name == :MathFunctions && continue
    isdefined(OceanSonar.MathFunctions, name) || continue
    fcn = getproperty(OceanSonar, name)
    nan_fcn = getproperty(OceanSonar.NaNMath, name)

    @check function behaves_nanly(x = floats)
        return isequal(fcn(x), nan_fcn(x))
    end

    @check function behaves_symbolically(x = floats)
        return fcn(x |> Num) isa Num
    end

    @check function behaves_intervally(x = intervals)
        y = interval(x[1], x[2])
        return fcn(y) isa OceanSonar.IntervalArithmetic.Interval
    end
end
