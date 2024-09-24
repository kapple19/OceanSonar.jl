using OceanSonar
using Test
using Supposition

@testset "Simple Example" begin
    texts = (
        Space = "Give NSW 32 Big Goodbyes to a Cruel NSW 1st World with 1 Hand",
        space = "give NSW 32 big goodbyes to a cruel NSW 1st world with 1 hand",
        Snake = "Give_NSW_32_Big_Goodbyes_to_a_Cruel_NSW_1st_World_with_1_Hand",
        snake = "give_NSW_32_big_goodbyes_to_a_cruel_NSW_1st_world_with_1_hand",
        Kebab = "Give-NSW-32-Big-Goodbyes-to-a-Cruel-NSW-1st-World-with-1-Hand",
        kebab = "give-NSW-32-big-goodbyes-to-a-cruel-NSW-1st-world-with-1-hand",
        pascal = "GiveNSW32BigGoodbyesToACruelNSW1stWorldWith1Hand",
        camel = "giveNSW32BigGoodbyesToACruelNSW1stWorldWith1Hand",
    )
    @testset "From $old_style" for (old_style, old_text) in pairs(texts)
        @testset "To $new_style" for (new_style, new_text) in pairs(texts)
            con_text = casetext(new_style, old_text)
            pass = new_text == con_text
            if !pass
                @show old_text
                @show new_text
                @show con_text
            end
            @test pass
        end
    end
end

# validchars = [
#     'A':'Z'...
#     'a':'z'...
#     '0':'9'...
#     [' ', '_', '-']...
# ]

# validchargen = Data.SampledFrom(validchars)
# validcharsgen = Data.Vectors(validchargen; min_size = 1, max_size = 20)

# casestyles = [:Space, :space, :Snake, :snake, :Kebab, :kebab, :Pascal, :pascal, :camel]

# @testset "Invertibility" begin
#     @testset "From $ref_style" for ref_style in casestyles
#         @testset "To $mid_style" for mid_style in casestyles
#             @check function invariance(chars = validcharsgen)
#                 ref_text = casetext(ref_style, chars |> String)
#                 mid_text = casetext(mid_style, ref_text)
#                 con_text = casetext(ref_style, mid_text)
#                 con_text == ref_text
#             end
#         end
#     end
# end
