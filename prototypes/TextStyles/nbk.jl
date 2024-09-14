### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ e9cde718-4786-4753-8cd6-cf5d54b1c907
using Test

# ╔═╡ 466bcb52-727e-11ef-1b6e-2fc4a1e9255d
using Supposition

# ╔═╡ 8621e71d-28f3-4fa4-9ba6-02da3bc0e060
KEEPTOKENS = [
    "a"; "to"; "the"; "with";
    "NSW";
    (["UL", "VL", "L", "M", "H", "VH", "UH"] .* "F");
    string.(1:3, "D")...
]

# ╔═╡ d286c1bb-4f89-4935-92b1-aafe506820df
PASCAL_REGEXES = [
	"([A-Z][A-Z])"
	"([a-z][A-Z])"
	"([0-9][A-Z])"
	"([a-z][0-9])"
	"([A-Z][0-9])"
]

# ╔═╡ 439e5669-1610-4a6e-b645-0f7bd787120e
function styletext(
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
end;

# ╔═╡ 59417e6f-4291-445f-af8b-9e4deac50bc7
begin
	stylesetup(::Val{:Space}) = (sep = " ", cap = true)
	stylesetup(::Val{:space}) = (sep = " ", cap = false)
	
	stylesetup(::Val{:Title}) = stylesetup(Val(:Space))
	stylesetup(::Val{:title}) = stylesetup(Val(:Space))
	
	stylesetup(::Val{:Snake}) = (sep = "_", cap = true)
	stylesetup(::Val{:snake}) = (sep = "_", cap = false)
	
	stylesetup(::Val{:Kebab}) = (sep = "-", cap = true)
	stylesetup(::Val{:kebab}) = (sep = "-", cap = false)
	
	stylesetup(::Val{:Pascal}) = (sep = "", cap = true)
	stylesetup(::Val{:pascal}) = stylesetup(Val(:Pascal))
end;

# ╔═╡ c8f44dac-6680-44ac-abd6-6a437b2f9307
function styletext(style::Val{S}, text::AbstractString; kws...) where {S}
	styletext(text; stylesetup(style)..., kws...)
end;

# ╔═╡ 8bb03021-6c86-4e2f-89bd-575d592fe81e
function styletext(style::Symbol, args...; kws...)
	styletext(style |> Val, args...; kws...)
end;

# ╔═╡ 9f83e3ea-bc9d-4710-8189-d61c4111ba76
function styletext(style::AbstractString, args...; kws...)
	styletext(style |> Symbol, args...; kws...)
end;

# ╔═╡ 6e603a09-73a9-4e89-b6ca-47e5a80d2157
function styletext(::Val{:camel}, text::AbstractString; kws...)
	isempty(text) && return ""
	text = styletext(text; stylesetup(Val(:Pascal))..., kws...)
	isempty(text) && return text
	return lowercase(text[1]) * if length(text) > 1
		text[2:end]
	else
		""
	end
end;

# ╔═╡ 40ab5607-8a36-4785-a3ae-8eeff1186c04
styletext(:Pascal, "Say32BigGoodbyesTo1CruelNSW1stWorld")

# ╔═╡ 7f2c8e6e-acc2-42e0-834f-6f740aa2fec5
styletext(:Kebab, "Say32BigGoodbyesTo1CruelNSW1stWorld")

# ╔═╡ 4a457e8b-1d4e-473a-96b6-642d9410d1ce
begin
	titletext(text::AbstractString; kws...) = styletext(:title, text; kws...)
	snaketext(text::AbstractString; kws...) = styletext(:snake, text; kws...)
	pascaltext(text::AbstractString; kws...) = styletext(:pascal, text; kws...)
end;

# ╔═╡ 4613a4ca-7f53-4c63-a9d5-d69f21294b1c
@show snaketext(@show titletext(@show snaketext("Uhf")));

# ╔═╡ 28cbdd9a-ca06-4aa1-9dd3-22f936195536
@testset "Set 1" begin
    texts = (
        Space = "Say 32 Big Goodbyes to 1 Cruel NSW 1st World",
        space = "say 32 big goodbyes to 1 cruel NSW 1st world",
        Snake = "Say_32_Big_Goodbyes_to_1_Cruel_NSW_1st_World",
        snake = "say_32_big_goodbyes_to_1_cruel_NSW_1st_world",
        Kebab = "Say-32-Big-Goodbyes-to-1-Cruel-NSW-1st-World",
        kebab = "say-32-big-goodbyes-to-1-cruel-NSW-1st-world",
        pascal = "Say32BigGoodbyesTo1CruelNSW1stWorld",
        camel = "say32BigGoodbyesTo1CruelNSW1stWorld",
    )
    @testset "From $old_style" for (old_style, old_text) in pairs(texts)
        @testset "To $new_style" for (new_style, new_text) in pairs(texts)
            con_text = styletext(new_style |> Symbol |> Val, old_text)
            @test con_text == new_text
        end
    end
end

# ╔═╡ 92d80ebe-1422-4df8-a660-9c5f9313110a
@testset "Set 2" begin
texts = (
    Space = "Say 32 Big Goodbyes to a Cruel NSW 1st World",
    space = "say 32 big goodbyes to a cruel NSW 1st world",
    Snake = "Say_32_Big_Goodbyes_to_a_Cruel_NSW_1st_World",
    snake = "say_32_big_goodbyes_to_a_cruel_NSW_1st_world",
    Kebab = "Say-32-Big-Goodbyes-to-a-Cruel-NSW-1st-World",
    kebab = "say-32-big-goodbyes-to-a-cruel-NSW-1st-world",
    pascal = "Say32BigGoodbyesToACruelNSW1stWorld",
    camel = "say32BigGoodbyesToACruelNSW1stWorld",
)
    @testset "From $old_style" for (old_style, old_text) in pairs(texts)
        @testset "To $new_style" for (new_style, new_text) in pairs(texts)
            con_text = styletext(new_style |> Symbol |> Val, old_text)
            @test con_text == new_text
        end
    end
end

# ╔═╡ cf4db81b-9fdf-437f-ab57-b5a6005b9bb4
validchars = [
	    'A':'Z'...
	    'a':'z'...
	    '0':'9'...
	    [' ', '_', '-']...
	];

# ╔═╡ 3d30633d-c385-4005-9162-8ab136bbef4d
validchargen = Data.SampledFrom(validchars)

# ╔═╡ 0959d28b-d60b-41d1-b8f1-0d8a93e353ae
validcharsgen = Data.Vectors(validchargen; min_size = 1, max_size = 20)

# ╔═╡ 5f607cbf-935e-46aa-b945-2b4bd3f531ba
let
	styles = [
		:Space, :space, :Snake, :snake, :Kebab, :kebab, :Pascal, :pascal, :camel
	]

	# Not sure what to call this
	@testset "Style Specification Types" begin
		@testset "$style" for style in styles
			@check function equivalent(chars = validcharsgen)
				text = chars |> String
				[
					styletext(style |> T, text)
					for T in [String, Symbol, Val]
				] |> allequal
			end
		end

		@testset "Convenience Methods" begin
			@check function title(chars = validcharsgen)
				text = chars |> String
				[
					titletext(text)
					styletext("Title", text)
					styletext("title", text)
					styletext(:Title, text)
					styletext(:title, text)
					styletext(:Title |> Val, text)
					styletext(:title |> Val, text)
				] |> allequal
			end
	
			@check function snake(chars = validcharsgen)
				text = chars |> String
				[
					snaketext(text)
					styletext("snake", text)
					styletext(:snake, text)
					styletext(:snake |> Val, text)
				] |> allequal
			end
	
			@check function pascal(chars = validcharsgen)
				text = chars |> String
				[
					pascaltext(text)
					styletext("Pascal", text)
					styletext("pascal", text)
					styletext(:Pascal, text)
					styletext(:pascal, text)
					styletext(:Pascal |> Val, text)
					styletext(:pascal |> Val, text)
				] |> allequal
			end
		end
	end
end

# ╔═╡ 69376254-3941-46e9-9bc2-917dd14adef8
let
	styles = [
		:Space, :space, :Snake, :snake, :Kebab, :kebab, :Pascal, :pascal, :camel
	]
	
	@testset "From $ref_style" for ref_style in styles
		@testset "To $mid_style" for mid_style in styles
			@check function invertible(chars = validcharsgen)
				ref_text = styletext(ref_style, chars |> String)
				mid_text = styletext(mid_style, ref_text)
				ref_text == styletext(ref_style, mid_text)
			end
		end
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Supposition = "5a0628fe-1738-4658-9b6d-0b7605a9755b"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
Supposition = "~0.3.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.0-rc3"
manifest_format = "2.0"
project_hash = "1165985ab745d21a547e8df522092e97c4e8cfc4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.HashArrayMappedTries]]
git-tree-sha1 = "2eaa69a7cab70a52b9687c8bf950a5a93ec895ae"
uuid = "076d061b-32b6-4027-95e0-9a2c6f6d7e74"
version = "0.2.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.RequiredInterfaces]]
deps = ["InteractiveUtils", "Logging", "Test"]
git-tree-sha1 = "c3250333ea2894237ed015baf7d5fcb8a1ea3169"
uuid = "97f35ef4-7bc5-4ec1-a41a-dcc69c7308c6"
version = "0.1.6"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.ScopedValues]]
deps = ["HashArrayMappedTries", "Logging"]
git-tree-sha1 = "eef2fbac9538ee6cc60ee1489f028d2f8a1a5249"
uuid = "7e506255-f358-4e82-b7e4-beb19740aa63"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.Supposition]]
deps = ["Logging", "Pkg", "PrecompileTools", "Printf", "Random", "RequiredInterfaces", "ScopedValues", "Serialization", "StyledStrings", "Test"]
git-tree-sha1 = "3a214d299ae8bfb8bee0eaf293690667d2ee80d8"
uuid = "5a0628fe-1738-4658-9b6d-0b7605a9755b"
version = "0.3.5"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═e9cde718-4786-4753-8cd6-cf5d54b1c907
# ╠═466bcb52-727e-11ef-1b6e-2fc4a1e9255d
# ╠═8621e71d-28f3-4fa4-9ba6-02da3bc0e060
# ╠═d286c1bb-4f89-4935-92b1-aafe506820df
# ╠═439e5669-1610-4a6e-b645-0f7bd787120e
# ╠═4613a4ca-7f53-4c63-a9d5-d69f21294b1c
# ╠═40ab5607-8a36-4785-a3ae-8eeff1186c04
# ╠═7f2c8e6e-acc2-42e0-834f-6f740aa2fec5
# ╠═59417e6f-4291-445f-af8b-9e4deac50bc7
# ╠═c8f44dac-6680-44ac-abd6-6a437b2f9307
# ╠═8bb03021-6c86-4e2f-89bd-575d592fe81e
# ╠═9f83e3ea-bc9d-4710-8189-d61c4111ba76
# ╠═6e603a09-73a9-4e89-b6ca-47e5a80d2157
# ╠═4a457e8b-1d4e-473a-96b6-642d9410d1ce
# ╠═5f607cbf-935e-46aa-b945-2b4bd3f531ba
# ╠═28cbdd9a-ca06-4aa1-9dd3-22f936195536
# ╠═92d80ebe-1422-4df8-a660-9c5f9313110a
# ╠═cf4db81b-9fdf-437f-ab57-b5a6005b9bb4
# ╠═3d30633d-c385-4005-9162-8ab136bbef4d
# ╠═0959d28b-d60b-41d1-b8f1-0d8a93e353ae
# ╠═69376254-3941-46e9-9bc2-917dd14adef8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
