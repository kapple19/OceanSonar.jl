using Test
using SafeTestsets

@testset "OceanSonar.jl" verbose = true begin
    @testset "Code Quality" verbose = true begin
        @safetestset "Aqua.jl" include("quality/aqua.jl")
        @safetestset "JET.jl" include("quality/jet.jl")
        @safetestset "Ambiguities" include("quality/ambiguities.jl")
        @safetestset "Docstrings" include("quality/docstrings.jl")
    end

    @testset "Auxiliary" verbose = true begin
        @safetestset "Series" include("auxiliary/series.jl")
        @safetestset "Univariate" include("auxiliary/interpolation/univariate.jl")
    end

    @testset "Modelling" verbose = true begin
        @safetestset "Concreteness" include("modelling/concreteness.jl")
        @safetestset "Type Stability" include("modelling/type_stability.jl")
        @safetestset "Model Stability" include("modelling/model_stability.jl")
    end

    @testset "Processing" verbose = true begin
        @safetestset "Sonar Types" include("processing/sonar_types.jl")
    end
end