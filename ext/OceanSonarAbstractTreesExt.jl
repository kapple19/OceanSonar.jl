module OceanSonarAbstractTreesExt
using OceanSonar
using AbstractTrees

import AbstractTrees: children

children(ST::Type{<:SonarType}) = subtypes(ST)
children(AM::Type{<:OceanSonar.AbstractModeller}) = subtypes(AM)

end