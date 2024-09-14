export styletext
export titletext
export snaketext
export pascaltext
public KEEPTOKENS

"""
```
OceanSonar.styletextseps
```

Used by [`styletext`](@ref).
`NamedTuple` of separators (delimiters) for different text style types.
"""
const styletextseps = (
    snake = '_',
    space = ' ',
    kebab = '-'
)

"""
```
OceanSonar.KEEPTOKENS
```

Used by [`styletext`](@ref).
`Vector` of `String`s of english language words (tokens)
to keep tokenised and keep their text styles
(for certain text style conversions by `styletext`).
"""
const KEEPTOKENS = [
    "a"; "to"; "the"
    "NSW";
    (["UL", "VL", "L", "M", "H", "VH", "UH"] .* "F");
    string.(1:3, "D")...
] |> uniquesort!

"""
`_styletext_casify_token(newstyle, token; keeptokens = OceanSonar.KEEPTOKENS)`

Converts a single token to its specified `newstyle`.
"""
function _styletext_casify_token(
    newstyle::AbstractString,
    token::AbstractString;
    keeptokens::AbstractVector{<:AbstractString} = KEEPTOKENS
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
`_styletext_verify_style`

Used by [`styletext`](@ref).
Verifies the request text style type.
"""
function _styletext_verify_style(::Val{C}) where {C}
    @assert C isa Symbol
    return String(C)
end

"""
```
styletext(
    newstyle :: Union{Symbol, <:AbstractString},
    oldtext :: Union{Symbol, <:AbstractString, <:Model{M}} where {M}
    ;
    keeptokens :: AbstractVector{<:AbstractString} = OceanSonar.KEEPTOKENS
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
* `:Kebab`: Hyphen-delimited tokens; tokens' first character uppercased except `keeptokens`.
* `:kebab`: Hyphen-delimited tokens; tokens' first character lowercased except `keeptokens`.

Examples of implemented text styles:

* `:Space`: `"Say 32 Big Goodbyes to 1 Cruel NSW 1st World"`
* `:space`: `"say 32 big goodbyes to 1 cruel NSW 1st world"`
* `:pascal`: `"Say32BigGoodbyesTo1CruelNSW1stWorld"`
* `:camel`: `"say32BigGoodbyesTo1CruelNSW1stWorld"`
* `:Snake`: `"Say_32_Big_Goodbyes_to_1_Cruel_NSW_1st_World"`
* `:snake`: `"say_32_big_goodbyes_to_1_cruel_NSW_1st_world"`
* `:Kebab`: `"Say-32-Big-Goodbyes-to-1-Cruel-NSW-1st-World"`
* `:kebab`: `"say-32-big-goodbyes-to-1-cruel-NSW-1st-world"`

The `title` case behaves differently from `Base.Unicode.titlecase`, e.g.

```jldoctest
julia> titlecase("say-32-big-goodbyes-to-1-cruel-NSW-1st-world")
"Say-32-Big-Goodbyes-To-1-Cruel-Nsw-1St-World"

julia> styletext(:title, "say-32-big-goodbyes-to-1-cruel-NSW-1st-world")
"Say 32 Big Goodbyes to 1 Cruel NSW 1st World"
```

The following convenience methods are also exported:

* [`titletext`](@ref)
* [`snaketext`](@ref)
* [`pascaltext`](@ref)
"""
function styletext(
    v::V,
    text::AbstractString;
    keeptokens::AbstractVector{<:AbstractString} = KEEPTOKENS
)::AbstractString where {
    V <: Union{
        Val{:snake}, Val{:space}, Val{:kebab},
        Val{:Snake}, Val{:Space}, Val{:Kebab},
        Val{:Pascal}
    }
}
    isempty(text) && return text

    tempsep = styletextseps.snake

    # Convert camel word separations to snake separations
    camel_regexes = [
        "[A-Z][A-Z]"
        "[a-z][A-Z]"
        "[0-9][A-Z]"
        "[a-z][0-9]"
        "[A-Z][0-9]"
    ] .|> Regex
    for camel_regex = camel_regexes
        regex_idxs_vec = findall(camel_regex, text, overlap = true)
        isempty(regex_idxs_vec) && continue

        text_idx_finals = push!([regex_idxs[begin] for regex_idxs in regex_idxs_vec], length(text))
        text_idx_firsts = pushfirst!([regex_idxs[end] for regex_idxs in regex_idxs_vec], 1)
        texts = [text[first:final] for (first, final) in zip(text_idx_firsts, text_idx_finals)]
        text = join(texts, tempsep)
    end

    isempty(text) && return text

    # Normalise existing separators
    normaliser_regex = r"(_| |-)(_| |-)"
    while contains(text, normaliser_regex)
        text = replace(text, normaliser_regex => tempsep)
    end
    text = replace(text, "-" => tempsep)
    text = replace(text, " " => tempsep)

    isempty(text) && return text

    # Remove non-alphanumeric symbols
    is_alphanumeric_or_tempsep(char::AbstractChar) = (isalphanumeric(char) || char == tempsep)
    text = filter(is_alphanumeric_or_tempsep, text)

    isempty(text) && return text

    # Remove leading and trailing separators
    while !isempty(text) && text[begin] == tempsep
        text = replace(text, Regex("^$tempsep") => "")
    end
    while !isempty(text) && text[end] == tempsep
        text = replace(text, Regex("$tempsep\$") => "")
    end

    isempty(text) && return text

    # Tokenise
    tokens = split(text, tempsep)

    newstyle = _styletext_verify_style(v)
    tokens = _styletext_casify_token.(newstyle, tokens, keeptokens = keeptokens)

    sep = if newstyle == "Pascal"
        ""
    else
        styletextseps[newstyle |> lowercase |> Symbol]
    end
    return join(tokens, sep)
end

function styletext(::Val{:camel}, text::AbstractString; keeptokens = KEEPTOKENS)
    text = styletext(Val(:Pascal), text; keeptokens = keeptokens)
    return lowercase(text[1]) * (length(text) > 1 ? text[2:end] : "")
end

function styletext(::Val{:pascal}, text::AbstractString; keeptokens = KEEPTOKENS)
    return styletext(Val(:Pascal), text; keeptokens = keeptokens)
end

function styletext(::Val{:title}, text::AbstractString; keeptokens = KEEPTOKENS)
    return styletext(Val(:Space), text; keeptokens = keeptokens)
end

function styletext(newstyle::Val, text::Union{Symbol, <:AbstractString}; keeptokens = KEEPTOKENS)
    return styletext(newstyle, text |> String; keeptokens = keeptokens)
end

function styletext(newstyle::Symbol, text::Union{Symbol, <:AbstractString}; keeptokens = KEEPTOKENS)
    return styletext(newstyle |> Val, text |> String; keeptokens = keeptokens)
end

function styletext(newstyle::AbstractString, text::Union{Symbol, <:AbstractString}; keeptokens = KEEPTOKENS)
    return styletext(newstyle |> Symbol, text |> String; keeptokens = keeptokens)
end

"""
```
titletext(text) -> ::AbstractString
pascaltext(text) -> ::AbstractString
snaketext(text) -> ::AbstractString
```

Converts the inputted `text` to the named text case style.

Convenience functions for [`styletext`](@ref),
internally calls e.g. `styletext(:title, text)`.
"""
function titletext(text; keeptokens = KEEPTOKENS)
    return styletext(Val(:title), text; keeptokens = keeptokens)
end

@doc (@doc titletext)
function pascaltext(text; keeptokens = KEEPTOKENS)
    return styletext(Val(:pascal), text; keeptokens = keeptokens)
end

@doc (@doc titletext)
function snaketext(text; keeptokens = KEEPTOKENS)
    return styletext(Val(:snake), text; keeptokens = keeptokens)
end
