### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ abecfe53-ff1b-457e-9f8a-1f2e891eba23
const KEEPTOKENS = [
    "a"; "to"; "the"; "with"
    "NSW"
    (["UL", "VL", "L", "M", "H", "VH", "UH"] .* "F")
    string.(1:3, "D")...
]

# ╔═╡ fae1b267-7021-47dc-a348-a60ebcde1af0
const PASCAL_REGEXES = [
	"([A-Z][A-Z])"
	"([a-z][A-Z])"
	"([0-9][A-Z])"
	"([a-z][0-9])"
	"([A-Z][0-9])"
]

# ╔═╡ e8a904cb-354b-4a46-8b0b-3cf7dbb9884f
begin
	abstract type AbstractTextCase{TC} end

	function AbstractTextCase(textcase::Symbol)
		cap = String(textcase)[1] |> isuppercase
		@assert textcase in subtypes(AbstractTextCase{T} where {T}) """
		$textcase not an implemented `subtype` of `AbstractTextCase`.
		Consider extending as a custom type as e.g.:

		```
		struct $textcase <: TextCases.AbstractTextCase{:$textcase} end
		TextCases.textcasesetup(::$textcase) = (sep = "<!>", cap = $cap)
		```
		"""
	end
end;

# ╔═╡ 0592e387-8ca4-4d52-9049-dc5f9a4c2803
function Core.String(::Type{TC}) where {TC <: AbstractTextCase}
	str = string(TC)
	idx = findlast('.', str)
	return str[idx+1 : end]
end

# ╔═╡ 6f3755af-b9b1-40b3-881e-5734f1f61bdf
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

# ╔═╡ 835325bb-53e1-4711-a524-4c5411877f0b
subtypes(AbstractTextCase)

# ╔═╡ 1b40d3b8-53ae-45dc-a693-8ab393ee2a07
begin
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
end

# ╔═╡ 2acf4471-9de2-4fd5-ad0b-a4f9e68a8b04
casesetup(::Space) = (sep = " ", cap = true)

# ╔═╡ f4994ae6-8f80-4f9e-89bd-13956229e3a2
casesetup(::space) = (sep = " ", cap = false)

# ╔═╡ 8ea4983d-ccef-49f5-aaec-f97df208f0fa
casesetup(::Title) = casesetup(Space())

# ╔═╡ 90114e4d-0f81-42ef-a314-1ad1d0b25b95
casesetup(::title) = casesetup(Title())

# ╔═╡ ec77f467-0954-49d9-b91c-5d355ab36caf
casesetup(::Snake) = (sep = "_", cap = true)

# ╔═╡ b6d4794a-91bb-408b-b01b-65d5a093423a
casesetup(::snake) = (sep = "_", cap = false)

# ╔═╡ 99832ead-c29d-4fa1-a48a-1d5022b73e19
casesetup(::Kebab) = (sep = "-", cap = true)

# ╔═╡ 0c4b4fa0-1219-4498-8045-fe0e2201d452
casesetup(::kebab) = (sep = "-", cap = false)

# ╔═╡ 67ad9095-6f15-42dd-8a6d-72a05d0f15ac
casesetup(::Pascal) = (sep = "", cap = true)

# ╔═╡ bc93ce3c-ec55-4376-a457-6d5be450865f
casesetup(::pascal) = casesetup(Pascal)

# ╔═╡ de947fb4-8fe3-47ff-97d2-f0d67bb7f40d
subtypes(AbstractTextCase) .|> String .|> Symbol

# ╔═╡ 0b7fa5c4-3597-486a-8ee2-c3b937d52be5
function casetext(textcase::AbstractTextCase{S}, text::AbstractString; kws...) where {S}
	casetext(text; casesetup(textcase)..., kws...)
end

# ╔═╡ 1d9ae2da-04ca-4e27-b78a-e275eb74011e
function casetext(textcase::AbstractTextCase{S}, text::Symbol; kws...) where {S}
    casetext(textcase, text |> string; kws...)
end

# ╔═╡ c7d75eb2-365b-4f55-a856-87604e6bc744
function casetext(textcase::Symbol, args...; kws...)
	casetext(textcase |> AbstractTextCase, args...; kws...)
end

# ╔═╡ 42587391-15d5-4d90-9349-df07eb54e893
function casetext(textcase::AbstractString, args...; kws...)
	casetext(textcase |> Symbol, args...; kws...)
end

# ╔═╡ 8481f288-f62a-4524-9299-6ab5d5e94ebe
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

# ╔═╡ 58386b5e-c0f8-40be-a71c-63bd18e7627b
casetext(::camel, text::AbstractTextCase; kws...) = casetext(Camel(), text; kws...)

# ╔═╡ ac852634-5e46-412f-a50d-bfbd5254971d
titletext(text; kws...) = casetext(title(), text; kws...)

# ╔═╡ 4da176bb-1962-45c2-a7ee-2fe89afaf5d9
snaketext(text; kws...) = casetext(snake(), text; kws...)

# ╔═╡ 248ce9d9-274c-47e6-af02-ced7853ce810
pascaltext(text; kws...) = casetext(pascal(), text; kws...)

# ╔═╡ 49893e07-76e6-4271-a643-520fb5b339b5
titletext("hello_world!@#\$%")

# ╔═╡ Cell order:
# ╠═abecfe53-ff1b-457e-9f8a-1f2e891eba23
# ╠═fae1b267-7021-47dc-a348-a60ebcde1af0
# ╠═6f3755af-b9b1-40b3-881e-5734f1f61bdf
# ╠═0592e387-8ca4-4d52-9049-dc5f9a4c2803
# ╠═e8a904cb-354b-4a46-8b0b-3cf7dbb9884f
# ╠═835325bb-53e1-4711-a524-4c5411877f0b
# ╠═1b40d3b8-53ae-45dc-a693-8ab393ee2a07
# ╠═2acf4471-9de2-4fd5-ad0b-a4f9e68a8b04
# ╠═f4994ae6-8f80-4f9e-89bd-13956229e3a2
# ╠═8ea4983d-ccef-49f5-aaec-f97df208f0fa
# ╠═90114e4d-0f81-42ef-a314-1ad1d0b25b95
# ╠═ec77f467-0954-49d9-b91c-5d355ab36caf
# ╠═b6d4794a-91bb-408b-b01b-65d5a093423a
# ╠═99832ead-c29d-4fa1-a48a-1d5022b73e19
# ╠═0c4b4fa0-1219-4498-8045-fe0e2201d452
# ╠═67ad9095-6f15-42dd-8a6d-72a05d0f15ac
# ╠═bc93ce3c-ec55-4376-a457-6d5be450865f
# ╠═de947fb4-8fe3-47ff-97d2-f0d67bb7f40d
# ╠═0b7fa5c4-3597-486a-8ee2-c3b937d52be5
# ╠═1d9ae2da-04ca-4e27-b78a-e275eb74011e
# ╠═c7d75eb2-365b-4f55-a856-87604e6bc744
# ╠═42587391-15d5-4d90-9349-df07eb54e893
# ╠═8481f288-f62a-4524-9299-6ab5d5e94ebe
# ╠═58386b5e-c0f8-40be-a71c-63bd18e7627b
# ╠═ac852634-5e46-412f-a50d-bfbd5254971d
# ╠═4da176bb-1962-45c2-a7ee-2fe89afaf5d9
# ╠═248ce9d9-274c-47e6-af02-ced7853ce810
# ╠═49893e07-76e6-4271-a643-520fb5b339b5
