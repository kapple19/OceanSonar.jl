visual!(::Type{Celerity}, med::Medium; kw...) = visual!(med.cel; kw...)
visual!(::Type{OceanSonar.Density}, med::Medium; kw...) = visual!(med.den; kw...)