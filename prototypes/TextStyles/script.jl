
const KEEPTOKENS = [
    "a"; "to"; "the"; "with"
    "NSW"
    (["UL", "VL", "L", "M", "H", "VH", "UH"] .* "F")
    string.(1:3, "D")...
]

const PASCAL_REGEXES = [
	"([A-Z][A-Z])"
	"([a-z][A-Z])"
	"([0-9][A-Z])"
	"([a-z][0-9])"
	"([A-Z][0-9])"
]

function casetext(
	text::AbstractString;
	sep::String = " ",
	cap::Bool = isempty(sep) ? true : false,
	keeptokens::AbstractVector{<:AbstractString} = KEEPTOKENS,
	pascal_regexes = PASCAL_REGEXES
)
	keeptokens = sort(keeptokens; by = length) |> reverse
	
	# Check
	isempty(text) && return ""

	midsep = ' '

	# Normalise separators
	function normalise_separators(txt)
		nonalphanumeric = r"[^((a-z)|(A-Z)|(\d))]"
		txt = replace(txt, nonalphanumeric => midsep)
		txt = replace(txt, r"\s+" => midsep)
		while !isempty(txt) && txt[begin] == midsep
			txt = txt[begin+1 : end]
		end
		while !isempty(txt) && txt[end] == midsep
			txt = txt[begin : end-1]
		end
		return txt
	end

	# Normalise then check
	text = normalise_separators(text)
	replace(text, midsep => "") |> isempty && return ""

	# Divide `keeptokens` from other characters 
	nonlowercase_keeptokens = [
		keeptoken
		for keeptoken in keeptokens
		if Vector{Char}(keeptoken) .|> islowercase |> any |> !
	]
	for keeptoken in nonlowercase_keeptokens
		for idxs in findall(keeptoken, text) |> reverse
			first = idxs[begin]
			final = idxs[end]

			prefix = first == 1 ? "" : text[firstindex(text) : first-1]
			suffix = final == length(text) ? "" : text[final+1 : lastindex(text)]

			text = prefix * midsep * keeptoken * midsep * suffix
		end
	end

	# Normalise then check
	text = normalise_separators(text)
	replace(text, midsep => "") |> isempty && return ""

	# Convert camel/pascal separations to `midsep` separations
	keeptoken_bounds_vec = [
		(first = idxs[begin], final = idxs[end])
		for keeptoken in keeptokens
		for idxs in findall(keeptoken, text)
	] # to avoid splitting `keeptokens`
	pascal_regex = join(pascal_regexes, '|') |> Regex
	for idxs in findall(pascal_regex, text, overlap = true) |> reverse
		first = idxs[begin]
		final = idxs[end]

		[
			keeptoken_bounds.first ≤ first && final ≤ keeptoken_bounds.final
			for keeptoken_bounds in keeptoken_bounds_vec
		] |> any && continue

		prefix = text[begin : first]
		suffix = text[final : end]
	
		text = prefix * midsep * suffix
	end

	# Normalise then check
	text = normalise_separators(text)
	replace(text, midsep => "") |> isempty && return ""

	function applycap(token)
		keep_idxs = findall(lowercase(token) .== lowercase.(keeptokens))
		return if !isempty(keep_idxs)
			@assert length(keep_idxs) == 1
			token = keeptokens[keep_idxs |> only]
			if sep == ""
				uppercase(token[1])
			else
				token[1]
			end * if length(token) > 1
				token[2:end]
			else
				""
			end

		elseif cap
			uppercase(token[1]) * if length(token) > 1
				lowercase(token[2:end])
			else
				""
			end

		else
			lowercase(token)
		end
	end

	return join(split(text, midsep) .|> applycap, sep)
end

abstract type AbstractTextCase{TC} end

function AbstractTextCase(TC::Symbol)

end

struct Space <: AbstractTextCase{:Space} end
struct space <: AbstractTextCase{:space} end
struct Title <: AbstractTextCase{:Title} end
struct title <: AbstractTextCase{:title} end
struct Snake <: AbstractTextCase{:Snake} end
struct snake <: AbstractTextCase{:snake} end
struct Kebab <: AbstractTextCase{:Kebab} end
struct kebab <: AbstractTextCase{:kebab} end
struct Pascal <: AbstractTextCase{:Pascal} end
struct pascal <: AbstractTextCase{:pascal} end
struct Camel <: AbstractTextCase{:Camel} end
struct camel <: AbstractTextCase{:camel} end

casesetup(::Space) = (sep = " ", cap = true)
casesetup(::space) = (sep = " ", cap = false)

casesetup(::Title) = casesetup(Space())
casesetup(::title) = casesetup(Title())

casesetup(::Snake) = (sep = "_", cap = true)
casesetup(::snake) = (sep = "_", cap = false)

casesetup(::Kebab) = (sep = "-", cap = true)
casesetup(::kebab) = (sep = "-", cap = false)

casesetup(::Pascal) = (sep = "", cap = true)
casesetup(::pascal) = casesetup(Pascal)

function casetext(textcase::AbstractTextCase, text::AbstractString; kws...) where {S}
	casetext(text; casesetup(textcase)..., kws...)
end

function casetext(textcase::AbstractTextCase, text::Symbol; kws...) where {S}
    casetext(textcase, text |> string; kws...)
end

function casetext(textcase::Symbol, args...; kws...)
	casetext(textcase |> AbstractTextCase, args...; kws...)
end

function casetext(textcase::AbstractString, args...; kws...)
	casetext(textcase |> Symbol, args...; kws...)
end

function casetext(::Camel, text::AbstractString; kws...)
	isempty(text) && return ""
	text = casetext(text; casesetup(Pascal())..., kws...)
	isempty(text) && return text
	return lowercase(text[1]) * if length(text) > 1
		text[2:end]
	else
		""
	end
end

casetext(::camel, text::abstractString; kws...) = casetext(Camel(), text; kws...)

titletext(text; kws...) = casetext(title, text; kws...)
snaketext(text; kws...) = casetext(snake, text; kws...)
pascaltext(text; kws...) = casetext(pascal, text; kws...)
