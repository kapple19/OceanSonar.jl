function modeltitle(ocnson::OcnSon)
    @assert hasproperty(ocnson, :model) "Structure is not a model instance."
    return ocnson.model |> modeltitle
end