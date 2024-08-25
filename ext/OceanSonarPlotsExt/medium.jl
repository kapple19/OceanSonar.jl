visual!(::Type{Celerity}, med::Medium; kw...) = visual!(med.cel; kw...)
visual!(::Type{Density}, med::Medium; kw...) = visual!(med.den; kw...)