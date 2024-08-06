export ModelName

struct ModelName{m} end

ModelName(name::Symbol) = ModelName{name}()

# ModelName(m::AbstractString) = ModelName{m |> snakecase |> Symbol}()
# ModelName(m::Symbol) = ModelName(m |> String)

Symbol(::ModelName{M}) where {M} = M
String(model::ModelName) = model |> ModelName |> String

# titletext(model::ModelName) = model |> String |> titletext
# snaketext(model::ModelName) = model |> String |> snaketext