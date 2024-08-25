### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 06b847e0-fcb2-11ea-1880-0543a2db1b1c
begin
	using Dierckx
	using Plots
end

# ╔═╡ 24e001e0-fcb2-11ea-0559-1b3da141b5a3
rAti = [0, 10, 20, 50, 100, 200, 500, 1e3, 2e3, 5e3, 1e4]

# ╔═╡ 9670e220-fcb2-11ea-37be-4f9bfa6437b1
zAti = [sin.(r/1e3) for r ∈ rAti]

# ╔═╡ a228e9f0-fcb2-11ea-1cd0-a7ef10379149
plot(rAti, zAti)

# ╔═╡ 2d598b10-fcb3-11ea-1579-4709585b2f96
# itpAti = LinearInterpolation(rAti, zAti)
splAti = Spline1D(rAti, zAti)

# ╔═╡ de70a04e-fcb3-11ea-1e68-3be191449dfb
# zAtiFcn(r) = itpAti(r)
zAtiFcn(r) = splAti(r)

# ╔═╡ 42fec5be-fcb3-11ea-2d2b-7df1958c48cf
begin
	r = range(0, rAti[end], length = 101)
	scatter(r, zAtiFcn)
	plot!(rAti, zAti)
end

# ╔═╡ fae441b0-fcb3-11ea-2baf-09505779f9a3
begin
	function InterpolatingFunction(rng, val)
		Itp = LinearInterpolation(rng, val)
		return ItpFcn(r) = Itp(r)
	end
	
	function InterpolatingFunction(rng, dpt, val)
		Itp = LinearInterpolation((dpt, rng), val)
		return ItpFcn(r, z) = Itp(z, r)
	end
end

# ╔═╡ 4ac0e5d0-fcb4-11ea-1477-0be39085827b
zAtiFcn2 = InterpolatingFunction(rAti, zAti)

# ╔═╡ 5cf89810-fcb4-11ea-194b-235bb415165c
scatter(r, zAtiFcn2)

# ╔═╡ 66914250-fcb4-11ea-20e3-07319a79a510
begin
	rc = rAti
	zc = [0, 10, 20, 100, 500, 1e3]
# 	c = 1550 .+ sin.(rc'/1e3) .+ sin.(zc/1e3)
	c = [1550 + sin(r/1e3) + sin(z/1e3) for z ∈ zc, r ∈ rc]
end

# ╔═╡ b45b8130-fcb4-11ea-0801-bd0afb438aca
heatmap(rc, zc, c)

# ╔═╡ cd252d60-fcb4-11ea-3112-d7f36a0f4c04
begin
	cItp = LinearInterpolation((zc, rc), c)
	cFcn(r, z) = cItp(z, r)
end

# ╔═╡ f3661d90-fcb4-11ea-0352-a5284b9dc242
begin
	z = range(0, zc[end], length = 101)
	heatmap(r, z, cFcn)
end

# ╔═╡ 28f73070-fcb5-11ea-0148-91f62d5ef3d7
begin
	zInd = 6
	zVal = zc[zInd]
	scatter(rc, c[zInd, :])
	plot!(r, r -> cFcn(r, zVal))
end

# ╔═╡ 5472ef00-fcb5-11ea-0640-672ede9c99b3
cFcn2 = InterpolatingFunction(rc, zc, c)

# ╔═╡ bd6c4be0-fcb6-11ea-1343-c1584a8f72d9
heatmap(r, z, cFcn2)

# ╔═╡ 984269a2-fcb9-11ea-04f1-0927fe41dfa3
cMat = vcat(hcat(0, transpose(rc)), hcat(zc, c))

# ╔═╡ 118e5a80-fcba-11ea-3a27-671c712ec008
begin
	rVec = [r for r ∈ cMat[1, 2:end]]
	zVec = [z for z ∈ cMat[2:end, 1]]
	cVec = cMat[2:end, 2:end]
end

# ╔═╡ b9c1e4ae-fcba-11ea-2d72-4778c0a74263
size(rVec), size(zVec), size(cVec)

# ╔═╡ 6adf09e0-fcba-11ea-2d8b-e5bbbece2d99
cFcn3 = InterpolatingFunction(rVec, zVec, cVec)

# ╔═╡ 4648ee10-fcbb-11ea-2247-735e9cb6e01d
heatmap(r, z, cFcn3)

# ╔═╡ Cell order:
# ╠═06b847e0-fcb2-11ea-1880-0543a2db1b1c
# ╠═24e001e0-fcb2-11ea-0559-1b3da141b5a3
# ╠═9670e220-fcb2-11ea-37be-4f9bfa6437b1
# ╠═a228e9f0-fcb2-11ea-1cd0-a7ef10379149
# ╠═2d598b10-fcb3-11ea-1579-4709585b2f96
# ╠═de70a04e-fcb3-11ea-1e68-3be191449dfb
# ╠═42fec5be-fcb3-11ea-2d2b-7df1958c48cf
# ╠═fae441b0-fcb3-11ea-2baf-09505779f9a3
# ╠═4ac0e5d0-fcb4-11ea-1477-0be39085827b
# ╠═5cf89810-fcb4-11ea-194b-235bb415165c
# ╠═66914250-fcb4-11ea-20e3-07319a79a510
# ╠═b45b8130-fcb4-11ea-0801-bd0afb438aca
# ╠═cd252d60-fcb4-11ea-3112-d7f36a0f4c04
# ╠═f3661d90-fcb4-11ea-0352-a5284b9dc242
# ╠═28f73070-fcb5-11ea-0148-91f62d5ef3d7
# ╠═5472ef00-fcb5-11ea-0640-672ede9c99b3
# ╠═bd6c4be0-fcb6-11ea-1343-c1584a8f72d9
# ╠═984269a2-fcb9-11ea-04f1-0927fe41dfa3
# ╠═118e5a80-fcba-11ea-3a27-671c712ec008
# ╠═b9c1e4ae-fcba-11ea-2d72-4778c0a74263
# ╠═6adf09e0-fcba-11ea-2d8b-e5bbbece2d99
# ╠═4648ee10-fcbb-11ea-2247-735e9cb6e01d
