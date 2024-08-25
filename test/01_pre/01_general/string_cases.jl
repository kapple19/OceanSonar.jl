using OceanSonar
using Test

texts = (
    Space = "Say 32.5 Big Goodbyes to 1 Cruel NSW 1st World",
    space = "say 32.5 big goodbyes to 1 cruel NSW 1st world",
    Snake = "Say_32.5_Big_Goodbyes_to_1_Cruel_NSW_1st_World",
    snake = "say_32.5_big_goodbyes_to_1_cruel_NSW_1st_world",
    Kebab = "Say-32.5-Big-Goodbyes-to-1-Cruel-NSW-1st-World",
    kebab = "say-32.5-big-goodbyes-to-1-cruel-NSW-1st-world",
    Camel = "Say32.5BigGoodbyesTo1CruelNSW1stWorld",
    camel = "say32.5BigGoodbyesTo1CruelNSW1stWorld",
)

@testset "From $oldcase" for (oldcase, oldtext) in pairs(texts)
    @testset "To $newcase" for (newcase, newtext) in pairs(texts)
        context = OceanSonar.stringcase(newcase |> Symbol |> Val, oldtext)
        @test context == newtext
    end
end