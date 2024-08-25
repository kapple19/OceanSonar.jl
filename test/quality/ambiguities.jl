using OceanSonar
using Test

ambiguities = Test.detect_ambiguities(OceanSonar)
@test length(ambiguities) == 0