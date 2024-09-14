using OceanSonar
using Test
using Supposition

validchars = [
    'A':'Z'...
    'a':'z'...
    '0':'9'...
    [' ', '_', '-']...
]

validchargen = Data.SampledFrom(validchars)
validcharsgen = Data.Vectors(validchargen; min_size = 1, max_size = 20)

converters = Dict(
    Symbol(converter) => converter
    for converter in [
        identity
        String
        Symbol
        pascaltext
        snaketext
        titletext
    ]
)

@testset "$conversion" for (conversion, converter) in converters
    @check function invariance(chars = validcharsgen)
        model = Model(chars |> String)
        model == Model(model |> converter)
    end
end
