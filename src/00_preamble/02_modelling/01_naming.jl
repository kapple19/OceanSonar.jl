export Model

"""
```
Model(name::AbstractString)
Model(name::Symbol)
```

Return `Model{name}()`
which is used to dispatch functions by model names.

The `name` is stored as a `Symbol` in [`pascaltext`](@ref) style,
i.e. only alphanumerals.
"""
struct Model{M}
    function Model(model::AbstractString)
        # check = @. isalphanumeric(model) || ismember(model, OceanSonar.textstyleseps |> values)
        valids = [
            isalphanumeric(ch) || ch in values(OceanSonar.textstyleseps)
            for ch in model
        ]

        if any(@. !valids)
            error("Invalid model name: $model. See the documentation of `Model` for more information.")
        end

        return new{
            model |> pascaltext |> Symbol
        }()
    end
end

Model(model::Symbol) = Model(model |> string)

Model(model::Model) = model

Model{M}() where {M} = Model(M)

"""
```

```

Overload of `Core.Symbol` for `OceanSonar.Model` types and instances.
"""
Symbol(::Type{Model{M}}) where {M} = M::Symbol
Symbol(model::Model) = model |> typeof |> Symbol

"""
```
```

Overload of `Core.Symbol` for `OceanSonar.Model types and instances`.
"""
String(::Type{Model{M}}) where {M} = M |> String
String(model::Model) = model |> typeof |> String

function textstyle(val::Val, ModelType::Type{Model{M}}; keeptokens = keeptokens) where {M}
    return textstyle(val, ModelType |> String; keeptokens = keeptokens)
end

function textstyle(val::Val, model::Model{M}; keeptokens = keeptokens) where {M}
    return textstyle(val, model |> typeof; keeptokens = keeptokens)
end
