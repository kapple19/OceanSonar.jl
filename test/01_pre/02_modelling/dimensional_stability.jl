using OceanSonar
using Test
using Supposition
using InteractiveUtils
using ProgressMeter
using Base.Threads

floatgen = Data.Floats{Float64}(infs = false)

allpars = (
    a = 500.0,
    b = 250e3,
    c = 250.0,
    f = 1e-4,
    s = 0.0
)

@showprogress desc = "2D Model Stability" for ModelFunctorType in subtypes(OceanSonar.ModelFunctor2D)
    @testset verbose = true "$ModelFunctorType" begin
        @testset verbose = true "$model" for model in list_models(ModelFunctorType)
            @check function dimensionally_stable_2D(
                x = floatgen,
                y = floatgen
            )
                parkeys = parameters(ModelFunctorType, model)
                pars = if isempty(parkeys)
                    NamedTuple()
                else
                    allpars[parkeys]
                end
            
                functor1D = ModelFunctorType{1}(model; pars...)
                functor2D = ModelFunctorType{2}(model; pars...)
                
                r = hypot(x, y)
                v1 = functor1D(r)
                v2 = functor2D(x, y)
            
                return allequal([v1, v2])
            end
        end
    end
end

allpars = (
    f = 1e3,
    ϵ = 7.37e-3,
    c₀ = 1500
)

desc = "3D Model Stability"
ModelFunctorTypes = subtypes(OceanSonar.ModelFunctor3D)
num_loops = [
    [
        1
        for model in list_models(ModelFunctorType)
    ] |> sum
    for ModelFunctorType in ModelFunctorTypes
] |> sum
prog = Progress(num_loops, desc = desc)
@info "Multithreading $desc with $(nthreads()) thread(s)"
@testset "$desc" begin
    @testset "$ModelFunctorType" for ModelFunctorType in ModelFunctorTypes
        @threads for model in list_models(ModelFunctorType)
            fcn_name = Symbol(String(ModelFunctorType) * "_" * String(model))
            quote
                @check function $fcn_name(
                    x = floatgen,
                    y = floatgen,
                    z = floatgen
                )
                    parkeys = parameters($ModelFunctorType, $model)
                    pars = if isempty(parkeys)
                        NamedTuple()
                    else
                        allpars[parkeys]
                    end
                
                    functor1D = $ModelFunctorType{1}($model, x, y; pars...)
                    functor2D = $ModelFunctorType{2}($model, x, y; pars...)
                    functor3D = $ModelFunctorType{3}($model; pars...)
                    
                    v1 = functor1D(z)
                    v2 = functor2D(0, z)
                    v3 = functor3D(x, y, z)
                    
                    return allequal([v1, v2, v3])
                end
            end |> eval
            next!(prog)
        end
    end
end
finish!(prog)