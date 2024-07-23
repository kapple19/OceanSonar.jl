export ModelName

struct ModelName{m} end

ModelName(m::Symbol) = ModelName(m |> String)

ModelName(m::AbstractString) = ModelName{m |> snakecase |> Symbol}()
