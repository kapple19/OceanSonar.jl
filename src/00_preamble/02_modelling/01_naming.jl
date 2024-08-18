export Model

"""
`struct Model{m} end`

Behaves like a stricter `Base.Val`.

`Model` is the chosen alternative from an overpopulation of this package's namespace.
"""
struct Model{M} end

Model(M::AbstractString) = Model{M |> pascaltext |> Symbol}()
Model(M::Symbol) = Model(M |> String)

Symbol(::Model{M}) where {M} = M
String(model::Model) = model |> Symbol |> String

titletext(model::Model) = model |> Symbol |> titletext
snaketext(model::Model) = model |> Symbol |> snaketext
