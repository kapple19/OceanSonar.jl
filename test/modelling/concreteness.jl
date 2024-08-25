using OceanSonar
using Test

exclusions = [
    RationalFunctionApproximation
]

for name in names(OceanSonar)
    property = getproperty(OceanSonar, name)

    property in exclusions && continue
    !(property isa Type) && continue
    !(property <: OceanSonar.OcnSon) && continue
    isabstracttype(property) && continue

    @testset "$name" begin
        @test isconcretetype(property)
    end
end