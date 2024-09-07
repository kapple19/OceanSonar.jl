using OceanSonar
using Test
using Supposition
using InteractiveUtils: subtypes

positivefloatvectors = Supposition.Data.Vectors(
    Supposition.Data.Floats{Float16}(;
        nans = false,
        minimum = 0
    );
    min_size = 2,
    max_size = 5
)

## TODO: Learn how to use generators.
@testset "Range Interpolation" begin
    @testset "$model" for model = listmodels(OceanSonar.RangeInterpolation)
        @info model
        @check function behaveswell(r = positivefloatvectors)
            @info r
            allunique(r) || return true

            r_itp = uniquesort(r)
            F_itp = rand(r_itp |> length)
            itp = OceanSonar.RangeInterpolation(model, F_itp, r_itp)
            F = @. itp(r_itp)
            if F != F_itp
                @show r_itp
                @show F_itp
                @show F
            end
            @. OceanSonar.ForwardDiff.derivative(itp, r_itp)
            return F == F_itp
        end
    end
end
