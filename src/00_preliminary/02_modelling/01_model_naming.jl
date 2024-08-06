export ModelName

struct ModelName{m} end

ModelName(m::AbstractString) = ModelName{m |> pascaltext |> Symbol}()
ModelName(m::Symbol) = ModelName(m |> String)

Symbol(::ModelName{M}) where {M} = M
String(model::ModelName) = model |> Symbol |> String

titletext(model::ModelName) = model |> Symbol |> titletext
snaketext(model::ModelName) = model |> Symbol |> snaketext
