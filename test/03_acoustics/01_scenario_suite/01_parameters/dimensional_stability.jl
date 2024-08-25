using OceanSonar
using Test
using Supposition
using InteractiveUtils
using ProgressMeter
using Base.Threads

floatgen = Data.Floats{Float64}(infs = false)

allpars(::Type{<:OceanSonar.ModellingFunctor}, ::Val) = NamedTuple()
allpars(modelling_functor::Type{<:OceanSonar.ModellingFunctor}, model::AbstractString) = allpars(modelling_functor, model |> modelval)
allpars(::Type{OceanAttenuation}, ::Val{:jensen}) = (f = 1e3,)
allpars(::Type{Altimetry}, ::Val{:damped_sinusoid}) = (a = 500.0, f = 1.0, s = 0.0, d = 100.0)
allpars(::Type{Bathymetry}, ::Val{:parabolic}) = (b = 250e3, c = 250.0)
allpars(::Type{OceanCelerity}, ::Val{:munk}) = (ϵ = 7.37e-3,)
allpars(::Type{OceanCelerity}, ::Val{:square_index}) = (c₀ = 1550.0,)

ModellingFunctorTypes = subtypes(OceanSonar.ModellingFunctor)
num_loops = [
    count(_ -> true, ModellingFunctorType |> listmodels)
    for ModellingFunctorType in ModellingFunctorTypes
] |> sum

compare(v1, v2) = if isnan(v1)
    v2 |> isnan
else
    isapprox(v1, v2, rtol = 1e-10)
end

@testset verbose = true "$ModellingFunctorType" for ModellingFunctorType in subtypes(OceanSonar.ModellingFunctor{2})
    for model in listmodels(ModellingFunctorType)
        test_function_name = Symbol(OceanSonar.stringcase("Snake", string(ModellingFunctorType) * model))
        @debug (ModellingFunctorType, model)
        @eval begin
            @check function $test_function_name(
                x = floatgen,
                y = floatgen
            )
                property_holds = true

                pars = allpars($ModellingFunctorType, $model)

                functor_origin = $ModellingFunctorType($model, 0, 0, 0; pars...)
                
                ref_value = functor_origin(x, y)

                functor_rotated = $ModellingFunctorType($model, 0, 0, atan(y, x); pars...)

                value = functor_rotated(OceanSonar.ocnson_hypot(x, y))
                property_holds *= compare(ref_value, value)

                functor_translated = $ModellingFunctorType($model, x, y, 0; pars...)

                value = functor_translated(0, 0)
                property_holds *= compare(ref_value, value)

                return property_holds
            end
        end
    end
end

@testset verbose = true "$ModellingFunctorType" for ModellingFunctorType in subtypes(OceanSonar.ModellingFunctor{3})
    for model in listmodels(ModellingFunctorType)
        test_function_name = Symbol(OceanSonar.stringcase("Snake", string(ModellingFunctorType) * model))
        @debug (ModellingFunctorType, model)
        @eval begin
            @check function $test_function_name(
                x = floatgen,
                y = floatgen,
                z = floatgen
            )
                property_holds = true

                pars = allpars($ModellingFunctorType, $model)

                functor_origin = $ModellingFunctorType($model, 0, 0, 0; pars...)
                
                ref_value = functor_origin(x, y, z)

                functor_rotated = $ModellingFunctorType($model, 0, 0, atan(y, x); pars...)

                value = functor_rotated(OceanSonar.ocnson_hypot(x, y), z)
                property_holds *= compare(ref_value, value)

                functor_translated = $ModellingFunctorType($model, x, y, 0; pars...)

                value = functor_translated(z)
                property_holds *= compare(ref_value, value)

                value = functor_translated(0, z)
                property_holds *= compare(ref_value, value)

                value = functor_translated(0, 0, z)
                property_holds *= compare(ref_value, value)

                return property_holds
            end
        end
    end
end

##
# using CairoMakie
# using OceanSonar

# Functor = Bathymetry
# model = "Parabolic"

# x::Float64 = 0.0
# y::Float64 = 8.326672684688674e-14
# θ = atan(y, x)
# r = ocnson_hypot(x, y)

# ati_ogn = Functor(model, 0, 0, 0)
# ati_rot = Functor(model, 0, 0, θ)
# ati_trn = Functor(model, x, y, 0)

# @show ati_ogn(x, y)
# @show ati_rot(r)
# @show ati_trn(0)
# @show ati_trn(0, 0)

# rvals = range(0, r, 301)
# xvals = rvals * cos(θ)
# yvals = rvals * sin(θ)
# zvals = ati_ogn.(xvals, yvals)

# lines(rvals, rvals .|> ati_rot) |> display
# lines(rvals, zvals) |> display
# lines(rvals, rvals .|> ati_trn) |> display

# nothing
