export textcase
export titletext
export snaketext
export pascaltext
# public keeptokens

const textcaseseps = (
    snake = '_',
    space = ' ',
    kebab = '-'
)

"""
Text conversions 
"""
const keeptokens = [
    "a"
    "to"
    "the"
    "NSW"
] |> uniquesort!

function _textcase_casify_token(
    newcase::AbstractString,
    token::AbstractString;
    keeptokens::AbstractVector{<:AbstractString} = keeptokens
)
    token = lowercase(token)

    idx = findall(token .== lowercase.(keeptokens))
    length(idx) > 1 && error("Non-unique `keeptokens` specified.")
    return if !isempty(idx)
        keeptoken = keeptokens[idx |> only]
        if newcase == "Pascal"
            uppercase(keeptoken[1]) * (length(keeptoken) > 1 ? keeptoken[2:end] : "")
        else
            keeptoken
        end
    elseif isuppercase(newcase[1])
        uppercase(token[1]) * (
            length(token) > 1 ? token[2:end] : ""
        )
    else
        token
    end
end

function _textcase_verify_case(::Val{C}) where {C}
    @assert C isa Symbol
    return String(C)
end

function textcase(
    v::V,
    text::AbstractString;
    keeptokens::AbstractVector{<:AbstractString} = keeptokens
) where {
    V <: Union{
        Val{:snake}, Val{:space}, Val{:kebab},
        Val{:Snake}, Val{:Space}, Val{:Kebab},
        Val{:Pascal}
    }
}
    tempsep = textcaseseps.snake

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
    texts = split(text, tempsep)

    newcase = _textcase_verify_case(v)
    texts = _textcase_casify_token.(newcase, texts, keeptokens = keeptokens)

    sep = if newcase == "Pascal"
        ""
    else
        textcaseseps[newcase |> lowercase |> Symbol]
    end
    return join(texts, sep)
end

function textcase(::Val{:camel}, text::AbstractString; keeptokens = keeptokens)
    text = textcase(Val(:Pascal), text; keeptokens = keeptokens)
    return lowercase(text[1]) * (length(text) > 1 ? text[2:end] : "")
end

function textcase(::Val{:pascal}, args...; kw...)
    return textcase(Val(:Pascal), args...; kw...)
end

function textcase(::Val{:title}, args...; kw...)
    return textcase(Val(:Space), args...; kw...)
end

titletext(text::AbstractString) = textcase(Val(:title), text)
snaketext(text::AbstractString) = textcase(Val(:snake), text)
pascaltext(text::AbstractString) = textcase(Val(:pascal), text)

prettytext(text::AbstractString) = titletext(text)
prettytext(text::Symbol) = text |> String |> prettytext
prettytext(::Val{T}) where {T} = T |> prettytext