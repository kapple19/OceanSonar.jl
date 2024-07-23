public stringcase
public titlecase
export snakecase
export kebabcase
export pascalcase

"""
Storage of all words that need to keep their case as is stored here,
e.g. acronyms, articles, prepositions, coordinating conjunctions, etc.
"""
keepcases = [
    "NSW"
    "the"
    "a"
    "to"
] |> uniquesort!

delims = (
    snake = "_",
    space = " ",
    kebab = "-"
)

_stringcasesep(::Val{C}) where C = delims[C]
_stringcasesep(::Val{:camel}) = ""
_stringcasesep(::Val{:Snake}) = _stringcasesep(:snake |> Val)
_stringcasesep(::Val{:Space}) = _stringcasesep(:space |> Val)
_stringcasesep(::Val{:Kebab}) = _stringcasesep(:kebab |> Val)
_stringcasesep(::Val{:Camel}) = _stringcasesep(:camel |> Val)
_stringcasesep(::Val{:pascal}) = _stringcasesep(:Camel |> Val)
_stringcasesep(::Val{:Pascal}) = _stringcasesep(:Camel |> Val)
_stringcasesep(::Val{:title}) = _stringcasesep(:Space |> Val)

function _firstcap(::Val{C}, char::Char) where C
    return if (C in (:pascal, :title)) || isuppercase(String(C)[1])
        uppercase(char)
    else
        lowercase(char)
    end
end

function _sepcap(::Val{C}, char::Char) where C
    return if (C in (:pascal, :title, :camel)) || isuppercase(String(C)[1])
        uppercase(char)
    else
        lowercase(char)
    end
end

function _wordseparation(case::Val{C}, text::AbstractString) where C
    text = text[1:end-1] * _sepcap(case, text[end])
end

function _caseconversions(::Val{C}, text::AbstractString; keepcases) where C
    boolkeepcase = lowercase(text) .== lowercase.(keepcases)
    iskeepcase = any(boolkeepcase)
    keepcase = if iskeepcase
        keepcases[boolkeepcase |> findall |> only]
    else
        ""
    end

    iscamel = C in (:pascal, :Pascal, :camel, :Camel)
    return if iskeepcase && (iscamel ? isuppercase(keepcase[1]) : true)
        keepcase
    elseif (C in (:pascal, :title, :camel)) || isuppercase(String(C)[1])
        uppercase(text[1]) * text[2:end]
    else
        text
    end
end

function stringcase(case::Val{C}, text::AbstractString; keepcases = keepcases) where C
    tempsep = delims.snake
    
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

    text = lowercase(text)

    # Convert any delimiters to snake delimiter
    text = replace(text, [sep => tempsep for sep in values(delims)]...)

    texts = split(text, tempsep)

    texts = [_caseconversions(case, text, keepcases = keepcases) for text in texts]

    text = join(texts, _stringcasesep(case))
    
    text = _firstcap(case, text[1]) * text[2:end]

    return text
end

stringcase(::Val{:Pascal}, text::AbstractString; keepcases = keepcases) = stringcase(:Camel |> Val, text; keepcases = keepcases)
stringcase(::Val{:pascal}, text::AbstractString; keepcases = keepcases) = stringcase(:Camel |> Val, text; keepcases = keepcases)
stringcase(::Val{:title}, text::AbstractString; keepcases = keepcases) = stringcase(:Space |> Val, text; keepcases = keepcases)

stringcase(case::Symbol, text::AbstractString; keepcases = keepcases) = stringcase(case |> Val, text; keepcases = keepcases)
stringcase(case::AbstractString, text::AbstractString; keepcases = keepcases) = stringcase(case |> Symbol, text; keepcases = keepcases)

titlecase(text::AbstractString; keepcases = keepcases) = stringcase(:Space |> Val, text; keepcases = keepcases)
snakecase(text::AbstractString; keepcases = keepcases) = stringcase(:snake |> Val, text; keepcases = keepcases)
kebabcase(text::AbstractString; keepcases = keepcases) = stringcase(:Kebab |> Val, text; keepcases = keepcases)
pascalcase(text::AbstractString; keepcases = keepcases) = stringcase(:Pascal |> Val, text; keepcases = keepcases)
