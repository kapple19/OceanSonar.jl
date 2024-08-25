using OceanSonar
using Test

for name in names(OceanSonar)
    property = getproperty(OceanSonar, name)

    !(property isa Type) && continue
    !(property <: OceanSonar.OcnSon) && continue
    isabstracttype(property) && continue

    @testset "$name" begin
        @test isconcretetype(property)
    end
end