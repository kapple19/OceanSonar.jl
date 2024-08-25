export title_case
export snake_case

# Temporary solution before I fix StringCases.jl
# Copying and editing files from StringCases.jl

const downcase = lowercase

function _purgecase(cur_string::AbstractString)
    cur_string = replace(cur_string, "-" => " ")
    cur_string = replace(cur_string, "_" => " ")
  
    cur_string
end

function _defaultcase(cur_string::AbstractString)
    cur_string = _purgecase(cur_string)
  
    cur_string = join(split(cur_string), " ")
    cur_string = downcase(cur_string)
  
    cur_string
end

function _delimcase(cur_string::AbstractString, cur_delim::AbstractString)
    replace(
         _defaultcase(cur_string),
        " " => cur_delim
    )
end

function snakecase(cur_string::AbstractString)
    _delimcase(cur_string, "_")
end

function spacecase(cur_string::AbstractString)
    _defaultcase(cur_string)
end

function decamelize(cur_string::AbstractString)
    capital_letters = collect(m.match for m in eachmatch(r"[A-Z]+", cur_string))
    capital_letters = map(x -> downcase(x), capital_letters)
  
    lowercase_phrases = split(cur_string, r"([A-Z]+)")
  
    cur_array = vcat(
        map(
            x -> join(x, "_"),
            [zip(lowercase_phrases, capital_letters)...]
        )...
    )
  
    cur_string = join(cur_array)
  
    if length(lowercase_phrases) > length(capital_letters)
        cur_string *= lowercase_phrases[end]
    end
  
    if length(lowercase_phrases) < length(capital_letters)
        error("Improperly handled string on decamelize: $cur_string")
    end
  
    ( startswith(cur_string, "_") ) && ( cur_string = cur_string[2:end] )
    ( startswith(cur_string, "-") ) && ( cur_string = cur_string[2:end] )
  
    cur_string
end

defaultcase(text::String) = text |> decamelize |> spacecase

title_case(text::String) = text |> defaultcase |> titlecase

snake_case = snakecase