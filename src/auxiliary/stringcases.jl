export snakecase

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
