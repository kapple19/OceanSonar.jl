export textstyle
export titletext
export snaketext
export pascaltext
# public keeptokens

"""
```
OceanSonar.textstyleseps
```

Used by [`textstyle`](@ref).
`NamedTuple` of separators (delimiters) for different text style types.
"""
const textstyleseps = (
    snake = '_',
    space = ' ',
    kebab = '-'
)

"""
```
OceanSonar.keeptokens
```

Used by [`textstyle`](@ref).
`Vector` of `String`s of english language words (tokens)
to keep tokenised and keep their text styles
(for certain text style conversions by `textstyle`).
"""
const keeptokens = [
    "a"; "to"; "the"
    "NSW";
    (["UL", "VL", "L", "M", "H", "VH", "UH"] .* "F")
] |> uniquesort!

"""
`_textstyle_casify_token(newstyle, token; keeptokens = OceanSonar.keeptokens)`

Converts a single token to its specified `newstyle`.
"""
function _textstyle_casify_token(
    newstyle::AbstractString,
    token::AbstractString;
    keeptokens::AbstractVector{<:AbstractString} = keeptokens
)
    token = lowercase(token)

    idx = findall(token .== lowercase.(keeptokens))
    length(idx) > 1 && error("Non-unique `keeptokens` specified.")
    return if !isempty(idx)
        keeptoken = keeptokens[idx |> only]
        if newstyle == "Pascal"
            uppercase(keeptoken[1]) * (length(keeptoken) > 1 ? keeptoken[2:end] : "")
        else
            keeptoken
        end
    elseif isuppercase(newstyle[1])
        uppercase(token[1]) * (
            length(token) > 1 ? token[2:end] : ""
        )
    else
        token
    end
end

"""
`_textstyle_verify_style`

Used by [`textstyle`](@ref).
Verifies the request text style type.
"""
function _textstyle_verify_style(::Val{C}) where {C}
    @assert C isa Symbol
    return String(C)
end

"""
```
textstyle(
    newstyle::Union{Symbol, AbstractString},
    oldtext::AbstractString
    ;
    keeptokens::AbstractVector{<:AbstractString} = OceanSonar.keeptokens
)
```

Converts `oldtext` into the requested `newstyle` text.

Implemented text styles:

* `:space`: Space-delimited tokens; tokens lowercased except `keeptokens` preserved.
* `:Title`/`:title`/`:Space`: Space-delimited tokens; tokens' first character uppercased except `keeptokens` preserved.
* `:Pascal`/`:pascal`: No token delimiter; tokens' first character uppercased except `keeptokens` preserved.
* `:camel`: As `:pascal` but the very first character of `text` is lowercase.
* `:Snake`: Underscore-delimited tokens; tokens' first character uppercased except `keeptokens` preserved.
* `:snake`: Underscore-delimited tokens; tokens' first character lowercased except `keeptokens` preserved.
* `:Kebab`: Dash-delimited tokens; tokens' first character uppercased except `keeptokens`.
* `:kebab`: Dash-delimited tokens; tokens' first character lowercased except `keeptokens`.

Examples of implemented text styles:

* `:Space`: "Say 32 Big Goodbyes to 1 Cruel NSW 1st World"
* `:space`: "say 32 big goodbyes to 1 cruel NSW 1st world"
* `:pascal`: "Say32BigGoodbyesTo1CruelNSW1stWorld"
* `:camel`: "say32BigGoodbyesTo1CruelNSW1stWorld"
* `:Snake`: "Say_32_Big_Goodbyes_to_1_Cruel_NSW_1st_World"
* `:snake`: "say_32_big_goodbyes_to_1_cruel_NSW_1st_world"
* `:Kebab`: "Say-32-Big-Goodbyes-to-1-Cruel-NSW-1st-World"
* `:kebab`: "say-32-big-goodbyes-to-1-cruel-NSW-1st-world"

The `title` case behaves differently from `Base.Unicode.titlecase`, e.g.

```julia
julia> titlecase("say-32-big-goodbyes-to-1-cruel-NSW-1st-world")
"Say-32-Big-Goodbyes-To-1-Cruel-Nsw-1St-World"

julia> textstyle(:title, "say-32-big-goodbyes-to-1-cruel-NSW-1st-world")
"Say 32 Big Goodbyes to 1 Cruel NSW 1st World"
```

The following convenience methods are also exported:

* [`titletext`](@ref)
* [`snaketext`](@ref)
* [`pascaltext`](@ref)
"""
function textstyle(
    v::V,
    text::AbstractString;
    keeptokens::AbstractVector{<:AbstractString} = keeptokens
)::AbstractString where {
    V <: Union{
        Val{:snake}, Val{:space}, Val{:kebab},
        Val{:Snake}, Val{:Space}, Val{:Kebab},
        Val{:Pascal}
    }
}
    tempsep = textstyleseps.snake

    # Convert camel word separations to snake separations
    camel_regexes = [
        "[a-z][A-Z]"
        "[0-9][A-Z]"
        "[a-z][0-9]"
        "[A-Z][0-9]"
    ] .|> Regex
    for camel_regex = camel_regexes
        text = replace(text,
            [
                text[idxs] => text[idxs[begin]] * tempsep * text[idxs[end]]
                for idxs in findall(camel_regex, text, overlap = true)
            ]...
        )
    end

    # Normalise existing separators
    normaliser_regex = r"(_| |-)(_| |-)"
    while contains(text, normaliser_regex)
        text = replace(text, normaliser_regex => tempsep)
    end
    text = replace(text, "-" => tempsep)
    text = replace(text, " " => tempsep)

    # Remove non-alphanumeric symbols
    is_alphanumeric_or_tempsep(char::AbstractChar) = (isalphanumeric(char) || char == tempsep)
    text = filter(is_alphanumeric_or_tempsep, text)

    # Tokenise
    tokens = split(text, tempsep)

    newstyle = _textstyle_verify_style(v)
    tokens = _textstyle_casify_token.(newstyle, tokens, keeptokens = keeptokens)

    sep = if newstyle == "Pascal"
        ""
    else
        textstyleseps[newstyle |> lowercase |> Symbol]
    end
    return join(tokens, sep)
end

function textstyle(::Val{:camel}, text::AbstractString; keeptokens = keeptokens)
    text = textstyle(Val(:Pascal), text; keeptokens = keeptokens)
    return lowercase(text[1]) * (length(text) > 1 ? text[2:end] : "")
end

function textstyle(::Val{:pascal}, text::AbstractString; keeptokens = keeptokens)
    return textstyle(Val(:Pascal), text; keeptokens = keeptokens)
end

function textstyle(::Val{:title}, text::AbstractString; keeptokens = keeptokens)
    return textstyle(Val(:Space), text; keeptokens = keeptokens)
end

"""
```
titletext(text) -> ::AbstractString
pascaltext(text) -> ::AbstractString
snaketext(text) -> ::AbstractString
```

Converts the inputted `text` to the named text case style.

Convenience functions for [`textstyle`](@ref),
internally calls e.g. `textstyle(:title, text)`.
"""
function titletext(text) textstyle(Val(:title), text) end

@doc (@doc titletext)
function pascaltext(text) textstyle(Val(:pascal), text) end

@doc (@doc titletext)
function snaketext(text) textstyle(Val(:snake), text) end
