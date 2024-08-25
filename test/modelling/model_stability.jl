using OceanSonar
using Test
using PropCheck
using InteractiveUtils

function wrap_check(prop::Function, gen::Integrated)
    chk = check(splat(prop), gen)
    chk isa Bool && return chk
    @info chk
    return prop(chk[1]...)
end

function model_parsers_equal(
    type::Type{<:OceanSonar.Functor}, model::String, inputs...
)
    vals = [
        type(model |> modeltitle)(inputs...)
        type(model |> modelsnake)(inputs...)
        type(model |> modelsymbol)(inputs...)
    ]
    val = type(model |> OceanSonar.modelval)(inputs...)
    return if isnan(val)
        isnan.(vals) |> all
    else
        all(val .== vals)
    end
end

function test_model_stability(
    type::Type{<:OceanSonar.Functor}, gen::Integrated
)
    for model in list_models(type)
        @testset "$model" verbose = true begin
            model_parsing_equality(args...) = model_parsers_equal(
                type, model, args...
            )

            @test wrap_check(model_parsing_equality, gen)
        end
    end
end

function construct_generator(::Type{T}) where T <: OceanSonar.Univariate
    itype(Float64)
end

function construct_generator(::Type{T}) where T <: OceanSonar.Bivariate
    itype(NTuple{2, Float64})
end

function construct_generator(::Type{T}) where T <: OceanSonar.Trivariate
    itype(NTuple{3, Float64})
end


function test_functor_model_stability(type::Type{<:OceanSonar.Functor})
    if isconcretetype(type)
        @testset "$type" verbose = true test_model_stability(
            type, construct_generator(type)
        )
    else
        for subtype in subtypes(type)
            test_functor_model_stability(subtype)
        end
    end
end

test_functor_model_stability(OceanSonar.Functor)

# for type in subtypes(OceanSonar.Functor)
#     if isconcretetype(type)
#         @testset "$type" verbose = true test_type_stability(type)
#     else
#         for subtype in subtypes(type)
#             @testset "$subtype" verbose = true test_type_stability(subtype)
#         end
#     end
# end

# univariate_types = (
#     altimetry,
#     bathymetry
# )

# @testset "Univariates" begin
#     for type in univariate_types
#         @testset "$type" test_model_stability(type, itype(Float64))
#     end
# end

# bivariate_types = (
#     atmosphere_celerity,
#     ocean_celerity,
#     seabed_celerity
# )

# @testset "Bivariates" begin
#     for type in bivariate_types
#         @testset "$type" test_model_stability(type, itype(Tuple{Float64, Float64}))
#     end
# end