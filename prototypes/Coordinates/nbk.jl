### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 76187030-e36b-4c1c-a28a-4c20480383cc
using Test

# ╔═╡ 2d2e96fc-bc4d-4394-8164-40c20a84e71a
using Supposition

# ╔═╡ fc6783b2-4f5c-4a27-8fe0-8073e0034346
md"""
# Coordinates
Getting some buggy Pluto behaviour.
Going to use Typst instead.
"""

# ╔═╡ 7f4f87a0-72aa-11ef-3b5d-991c67749fe5
begin
	abstract type AbstractCoordinate end

	struct NonSpatial <: AbstractCoordinate end
	struct Abscissa <: AbstractCoordinate end
	struct Ordinate <: AbstractCoordinate end
	struct Height <: AbstractCoordinate end
	struct Depth <: AbstractCoordinate end
	struct Range <: AbstractCoordinate end
	struct Radius <: AbstractCoordinate end
	struct Azimuth <: AbstractCoordinate end
	struct Elevation <: AbstractCoordinate end
	struct Declination <: AbstractCoordinate end
end

# ╔═╡ a5514c28-2237-49a6-9c6d-08cc3b54121f
begin
	import Core: String
	
	function String(::Type{AC}) where {AC <: AbstractCoordinate}
		str = string(AC)
		idx = findlast('.', str)
		return str[idx+1 : end]
	end

	String(::AC) where {AC <: AbstractCoordinate} = String(AC)
end

# ╔═╡ 183ec0b3-00cb-4c3c-a717-a9e5a268ad38
md"## 1D ``\rightarrow`` 1D"

# ╔═╡ 9a0e49c9-e209-4444-a0b8-1a617b816254
"""
Identity Transformation
"""
function transform(
	::AC,
	::AC,
	v::Real
) where {AC <: AbstractCoordinate}
	return v
end;

# ╔═╡ 39391608-52c3-42cd-b26c-236f60bfec00
function transform(
	::Height,
	::Depth,
	z::Real
)
	return -z
end;

# ╔═╡ ea087cd8-3fc1-45ba-ba95-2418db8eb882
function transform(
	::Depth,
	::Height,
	z::Real
)
	return -z
end;

# ╔═╡ 3340f3e1-8405-4e18-9b03-fc75d3a30fee
function transform(
	::Elevation,
	::Declination,
	ϕ::Real
)
	return -ϕ
end;

# ╔═╡ 2f2b0665-532a-404e-91a6-cef80776ac7a
function transform(
	::Declination,
	::Elevation,
	ϕ::Real
)
	return -ϕ
end;

# ╔═╡ 31efc42d-e16b-4fb6-bc34-2489b2ab7b42
function transform(
	old::Tuple{<:AbstractCoordinate},
	new::Tuple{<:AbstractCoordinate},
	v::Real
)
	transform(old[1], new[1], v)
end;

# ╔═╡ aa7b3b73-0a03-469c-9ef6-b9366bc4cc4e
# function transform(
# 	old::Tuple{OT},
# 	new::Tuple{NT},
# 	v::Real
# ) where {OT <: AbstractCoordinate, NT <: AbstractCoordinate}
# 	transform(old[1], new[1], v)
# end;

# ╔═╡ 16b378b8-b4b0-4e8c-96a2-7bd951aa8d11
md"### Tests"

# ╔═╡ 9f89ae50-1825-4a21-bd7d-91390a55c7ef
md"## 2D"

# ╔═╡ 87326805-c8c2-4064-a852-96314a2df0c9
function transform(
	::Tuple{Abscissa, Ordinate},
	::Tuple{Range},
	x::Real, y::Real
)
	hypot(x, y)
end;

# ╔═╡ 81d435a8-a22c-44c6-96ef-741a456583e7
function transform(
	::Tuple{Range, Azimuth},
	::Tuple{Abscissa},
	r::Real, θ::Real
)
	r * cos(θ)
end;

# ╔═╡ 668e2439-ab6c-4239-b0dd-9c2b1e6d29d2
function transform(
	::Tuple{Range, Azimuth},
	::Tuple{Ordinate},
	r::Real, θ::Real
)
	r * sin(θ)
end;

# ╔═╡ 94ef7a54-799b-4c5f-af8c-5e80a8202635
function transform(
	::Tuple{Range, Height},
	::Tuple{Radius},
	r::Real, z::Real
)
	hypot(r, z)
end;

# ╔═╡ d8c3b45b-6c63-4cae-9c5f-bb823b1b1071
function transform(
	::Tuple{Range, Height},
	::Tuple{Elevation},
	r::Real, z::Real
)
	atand(Height, Range)
end;

# ╔═╡ 2ad27f50-f7cc-4754-b154-378e0a35758f
function transform(
	old::Tuple{Range, Azimuth},
	new::Tuple{Abscissa, Ordinate},
	r::Real, θ::Real
)
	(
		transform(old, new[1], r, θ),
		transform(old, new[2], r, θ)
	)
end;

# ╔═╡ b201689a-6ce0-47e8-8556-91ff561312b0
function transform(
	::Tuple{Range, Height},
	::Tuple{Radius, Elevation},
	r::Real, z::Real
)
	
end;

# ╔═╡ f46cfd76-7b00-4c33-8462-52ba21d7389e
let
	@testset "Univariate Transformations" begin
		@testset "Identity Transformation" begin
			@testset "$(CoordinateType |> String)" for CoordinateType in subtypes(AbstractCoordinate)
				C = CoordinateType()
				@check function identity_transformation(v = Data.Floats())
					[
						v
						transform(C, C, v)
						transform((C,), (C,), v)
					] |> allequal
				end
			end
		end

		@testset "Reflective Transformation" begin
			CoordinatePairs = (
				Vertical = (Depth, Height),
				Polar = (Elevation, Declination)
			)
			@testset "$PairType" for PairType in keys(CoordinatePairs)
				(C1, C2) = CoordinatePairs[PairType]
				@check function reflective_transformation(v = Data.Floats())
					@show C1
					@show C2
					transform(C1(), C2(), v) == -transform(C2(), C1(), v)
				end
			end
		end
	end
end;

# ╔═╡ 05312047-1418-40e9-9a61-0a5eb172c0e2
transform((Depth(),), (Height(),), 1e3)

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
# ╟─fc6783b2-4f5c-4a27-8fe0-8073e0034346
# ╠═76187030-e36b-4c1c-a28a-4c20480383cc
# ╠═2d2e96fc-bc4d-4394-8164-40c20a84e71a
# ╠═7f4f87a0-72aa-11ef-3b5d-991c67749fe5
# ╠═a5514c28-2237-49a6-9c6d-08cc3b54121f
# ╟─183ec0b3-00cb-4c3c-a717-a9e5a268ad38
# ╠═9a0e49c9-e209-4444-a0b8-1a617b816254
# ╠═39391608-52c3-42cd-b26c-236f60bfec00
# ╠═ea087cd8-3fc1-45ba-ba95-2418db8eb882
# ╠═3340f3e1-8405-4e18-9b03-fc75d3a30fee
# ╠═2f2b0665-532a-404e-91a6-cef80776ac7a
# ╠═31efc42d-e16b-4fb6-bc34-2489b2ab7b42
# ╠═aa7b3b73-0a03-469c-9ef6-b9366bc4cc4e
# ╟─16b378b8-b4b0-4e8c-96a2-7bd951aa8d11
# ╠═f46cfd76-7b00-4c33-8462-52ba21d7389e
# ╟─9f89ae50-1825-4a21-bd7d-91390a55c7ef
# ╠═87326805-c8c2-4064-a852-96314a2df0c9
# ╠═81d435a8-a22c-44c6-96ef-741a456583e7
# ╠═668e2439-ab6c-4239-b0dd-9c2b1e6d29d2
# ╠═94ef7a54-799b-4c5f-af8c-5e80a8202635
# ╠═d8c3b45b-6c63-4cae-9c5f-bb823b1b1071
# ╠═2ad27f50-f7cc-4754-b154-378e0a35758f
# ╠═b201689a-6ce0-47e8-8556-91ff561312b0
# ╠═05312047-1418-40e9-9a61-0a5eb172c0e2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
