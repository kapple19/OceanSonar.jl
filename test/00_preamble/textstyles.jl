using OceanSonar
using Test

text = "Say 32 Big Goodbyes to 1 Cruel NSW 1st World"

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

@testset "From $oldstyle" for (oldstyle, oldtext) in pairs(texts)
    @testset "To $newstyle" for (newstyle, newtext) in pairs(texts)
        context = styletext(newstyle |> Symbol |> Val, oldtext)
        @test context == newtext
    end
end

texts = (
    Space = "Say 32 Big Goodbyes to a Cruel NSW 1st World",
    space = "say 32 big goodbyes to a cruel NSW 1st world",
    Snake = "Say_32_Big_Goodbyes_to_a_Cruel_NSW_1st_World",
    snake = "say_32_big_goodbyes_to_a_cruel_NSW_1st_world",
    Kebab = "Say-32-Big-Goodbyes-to-a-Cruel-NSW-1st-World",
    kebab = "say-32-big-goodbyes-to-a-cruel-NSW-1st-world",
    pascal = "Say32BigGoodbyesToACruelNSW1stWorld",
    camel = "say32BigGoodbyesToACruelNSW1stWorld",
)

@testset "From $oldstyle" for (oldstyle, oldtext) in pairs(texts)
    @testset "To $newstyle" for (newstyle, newtext) in pairs(texts)
        context = styletext(newstyle |> Symbol |> Val, oldtext)
        if oldstyle in [:pascal, :camel]
            @test_broken context == newtext
        else
            @test context == newtext
        end
    end
end
