export modelval
export modeltitle
export modelsnake
export modelkebab
export modelpretty

modelval(model::AbstractString) = model |> snakecase |> Symbol |> Val
modelval(model::Symbol) = model |> String |> modelval
modelval(::Val{model}) where model = model |> modelval

modeltitle(model::AbstractString) = model |> titlecase
modeltitle(::Val{model}) where model = model |> String |> modeltitle
modeltitle(model::Symbol) = model |> String |> modeltitle

modelsnake(model::AbstractString) = model |> snakecase
modelsnake(::Val{model}) where model = model |> String |> modelsnake
modelsnake(model::Symbol) = model |> String |> modelsnake

modelkebab(model::AbstractString) = model |> kebabcase
modelkebab(::Val{model}) where model = model |> String |> modelkebab
modelkebab(model::Symbol) = model |> String |> modelkebab

function modelpretty end