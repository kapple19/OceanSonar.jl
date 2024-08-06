children(ST::Type{<:SonarType}) = subtypes(ST)
children(AM::Type{<:OceanSonar.AbstractModeller}) = subtypes(AM)