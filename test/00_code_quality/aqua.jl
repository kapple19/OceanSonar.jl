using OceanSonar
using Aqua

Aqua.test_all(OceanSonar,
    ambiguities = (broken = true,) # inherits ambiguities from dependencies
)