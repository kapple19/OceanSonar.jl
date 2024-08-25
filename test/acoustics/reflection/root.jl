@testset "Reflection" verbose = true begin
    angle_triplets = [
        (0, -90, 90),
        (0, -45, 45),
        (0, 0, 0),
        (0, 45, -45),
        (0, 90, -90),
        (45, -90, -180),
        (45, -45, 135),
        (45, 0, 90),
        (45, 45, 45),
        (45, 90, 0),
        (-45, -90, 0),
        (-45, -45, -45),
        (-45, 0, -90),
        (-45, 45, -135),
        (-45, 90, -180)
    ]

    @testset "Angle" for triplet in angle_triplets::Vector{<:NTuple{3, <:Real}}
        @test OceanSonar.reflection_angle_degrees(triplet[1:2]...) == triplet[3]
    end
end