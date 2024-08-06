using OceanSonar
using Test

texts = (
    Space = "Say 32 Big Goodbyes to 1 Cruel NSW 1st World",
    space = "say 32 big goodbyes to 1 cruel NSW 1st world",
    Snake = "Say_32_Big_Goodbyes_to_1_Cruel_NSW_1st_World",
    snake = "say_32_big_goodbyes_to_1_cruel_NSW_1st_world",
    Kebab = "Say-32-Big-Goodbyes-to-1-Cruel-NSW-1st-World",
    kebab = "say-32-big-goodbyes-to-1-cruel-NSW-1st-world",
    pascal = "Say32BigGoodbyesTo1CruelNSW1stWorld",
    camel = "say32BigGoodbyesTo1CruelNSW1stWorld",
)

@testset "From $oldcase" for (oldcase, oldtext) in pairs(texts)
    @testset "To $newcase" for (newcase, newtext) in pairs(texts)
        context = textcase(newcase |> Symbol |> Val, oldtext)
        @test context == newtext
    end
end