### A Pluto.jl notebook ###
# v0.11.12

using Markdown
using InteractiveUtils

# ╔═╡ 34968600-f1c6-11ea-2d29-d300e57ea2e8
begin
	using Images
	using FileIO
	using Plots
end

# ╔═╡ 5184395e-f1c6-11ea-2587-6f04898233c2
SvpImg = load("../img/SVP_ConvergenceZonePropagation.png")

# ╔═╡ a36d9d70-f1c6-11ea-37d9-b77d507d806d
NumRows, NumCols = size(SvpImg)

# ╔═╡ df563950-f1c6-11ea-25ed-a3210bbc3e71
begin
	zMin = 0.
	zMax = 5e3
	cMin = 1490.
	cMax = 1550.
	
	# 256
	nRows = 327 : NumRows - 245
	nCols = 1405 : NumCols - 1144
	SvpCrop = SvpImg[nRows, nCols]
end

# ╔═╡ 7c1af8b0-f1d2-11ea-34f3-8522ccac0729
Nrows, Ncols = size(SvpCrop)

# ╔═╡ f03896f0-f1d5-11ea-33f1-37d138cbf3f0
begin
	LinearTransform(Min, Max, N, n) = Min + (Max - Min)*n/N
	n2c(nc) = LinearTransform(cMin, cMax, Ncols, nc)
	n2z(nz) = LinearTransform(zMin, zMax, Nrows, nz)
end

# ╔═╡ 17a4a102-f1d3-11ea-1751-ef912f9d0d42
begin
	Svp₁ = copy(SvpCrop)
	
	nc₁ = (Ncols ÷ 2) + 12
	Svp₁[:, nc₁] .= RGB(0, 0, 1)
	
	z₁ = n2z(1)
# 	z₁ = 0.
	c₁ = cMin + (cMax - cMin)*nc₁/Ncols
# 	c₁ = 1520
	
	Svp₁
end

# ╔═╡ c55b30b0-f1d4-11ea-173a-3f19bf11e577
begin
	Svp₂ = copy(SvpCrop)
	
	nz₂ = (Nrows ÷ 15) - 8
	Svp₂[nz₂, :] .= RGB(1, 0, 0)
	
	nc₂ = (Ncols ÷ 4) - 25
	Svp₂[:, nc₂] .= RGB(0, 0, 1)
	
	z₂ = n2z(nz₂)
	c₂ = n2c(nc₂)
	
	Svp₂
end

# ╔═╡ 9e2aec90-f1d6-11ea-1f25-5f02cc093c6f
begin
	Svp₃ = copy(SvpCrop)
	
	nz₃ = (Nrows ÷ 4) - 13
	Svp₃[nz₃, :] .= RGB(1, 0, 0)
	
	nc₃ = (Ncols ÷ 3) + 33
	Svp₃[:, nc₃] .= RGB(0, 0, 1)
	
	z₃ = n2z(nz₃)
	c₃ = n2c(nc₃)
	
	Svp₃
end

# ╔═╡ 0682327e-f1d7-11ea-2a37-af5ebb964d12
begin
	Svp₄ = copy(SvpCrop)
	
	nz₄ = (Nrows ÷ 3) + 90
	Svp₄[nz₄, :] .= RGB(1, 0, 0)
	
	nc₄ = (Ncols ÷ 5) - 40
	Svp₄[:, nc₄] .= RGB(0, 0, 1)
	
	z₄ = n2z(nz₄)
	c₄ = n2c(nc₄)
	
	Svp₄
end

# ╔═╡ 8a44d190-f1d7-11ea-209d-e3d44ffa8f23
begin
	Svp₅ = copy(SvpCrop)
	
	nz₅ = Nrows
	Svp₅[nz₅, :] .= RGB(1, 0, 0)
	
	nc₅ = Ncols - 38
	Svp₅[:, nc₅] .= RGB(0, 0, 1)
	
	z₅ = n2z(nz₅)
	c₅ = n2c(nc₅)
	
	Svp₅
end

# ╔═╡ b8b4aa30-f1d4-11ea-12e1-090b74b2ea67
z = [z₁, z₂, z₃, z₄, z₅]

# ╔═╡ fa7166e0-f1d7-11ea-37ee-43fe6df8aa24
c = [c₁, c₂, c₃, c₄, c₅]

# ╔═╡ fe0c40e0-f1d7-11ea-0402-83ae99b738f4
begin
	plot(c, z, yaxis = :flip)
	plot!([1520, 1500, 1515, 1495, 1545.], [0., 300., 1200., 2e3, 5000.])
end

# ╔═╡ Cell order:
# ╠═34968600-f1c6-11ea-2d29-d300e57ea2e8
# ╠═5184395e-f1c6-11ea-2587-6f04898233c2
# ╠═a36d9d70-f1c6-11ea-37d9-b77d507d806d
# ╠═df563950-f1c6-11ea-25ed-a3210bbc3e71
# ╠═7c1af8b0-f1d2-11ea-34f3-8522ccac0729
# ╠═f03896f0-f1d5-11ea-33f1-37d138cbf3f0
# ╠═17a4a102-f1d3-11ea-1751-ef912f9d0d42
# ╠═c55b30b0-f1d4-11ea-173a-3f19bf11e577
# ╠═9e2aec90-f1d6-11ea-1f25-5f02cc093c6f
# ╠═0682327e-f1d7-11ea-2a37-af5ebb964d12
# ╠═8a44d190-f1d7-11ea-209d-e3d44ffa8f23
# ╠═b8b4aa30-f1d4-11ea-12e1-090b74b2ea67
# ╠═fa7166e0-f1d7-11ea-37ee-43fe6df8aa24
# ╠═fe0c40e0-f1d7-11ea-0402-83ae99b738f4
