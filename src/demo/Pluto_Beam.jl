### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 1968f0a2-fde4-11ea-3a5e-c1fc5176627f
begin
	using Plots
	using IntervalRootFinding
	using IntervalArithmetic
	
	include("../AcousticPropagation.jl")
end

# ╔═╡ 34c9dff0-fdd8-11ea-383b-b3c3d5e3bbe8
md"""
# Beam Tracing
```math
\newcommand{\Par}[1]{\left({#1}\right)}
\newcommand{\Brace}[1]{\left\{{#1}\right\}}
\newcommand{\Brack}[1]{\left[{#1}\right]}
```
"""

# ╔═╡ 3e7e5a20-fdd9-11ea-3a3b-31fe9237e71e
md"""
In this document, we take the step forward from having solved the eikonal, first transport equation, and dynamic ray equations which gives us the following instantaneous ray parameters:
* Length $s$
* Range $r(s)$
* Depth $z(s)$
* Tangent range component $\xi = \dfrac{\cos\Par{\theta(s)}}{c(s)}$
* Tangent depth component $\zeta = \dfrac{\sin(\theta)}{c(s)}$
* Time $\tau\Par{s} = \dfrac{s}{c(s)}$
* Pace $p(s) = \dfrac{1}{c(s)}$
* Spreading $q(s)$
* Angle $\theta(s)$
* Speed $c(s)$
"""

# ╔═╡ 6edbdfb0-fddb-11ea-1b8d-3dd87aa01386
md"""
These variables allow us to approximate the ray series
```math
p\Par{\vec{x}} = e^{i\omega\tau\Par{\vec{x}}} \sum_{j = 0}^\infty \frac{A_j\Par{\vec{x}}}{\Par{i\omega}^j}.
```
Along the length of the ray,
```math
p(s) = e^{i\omega\tau(s)} \sum_{j = 0}^\infty \frac{A_j(s)}{\Par{i\omega}^j}
```
"""

# ╔═╡ d2c2a7f0-fde2-11ea-16ad-ab1114259f56
md"""
The initial conditions for $p(s)$ and $q(s)$ allow us to implement different beam tracing methods.
"""

# ╔═╡ fdf32220-fde1-11ea-25e6-9db949c15ec2
md"""
## Gaussian Beams
The initial conditions for the pace $p(s)$ and spreading $q(s)$ for calculating Gaussian beams are
```math
\begin{align*}
p(0) &= 1 \\
q(0) &= \frac{i\omega W(0)^2}{2}
\end{align*}
```
"""

# ╔═╡ 75c3a120-fde3-11ea-1682-87e3dc7aee71
md"""
The equation for the beam is given by
```math
p^\textrm{beam}(s, n) = A \sqrt{\frac{c(s)}{rq(s)}} \exp\Brace{-i\omega\Brack{\tau(s) + \frac{p(s)}{q(s)}\frac{n^2}{2}}}
```
"""

# ╔═╡ 73d6a8c0-fde4-11ea-237d-15e08ebdaa1c
begin
	z_c = [0., 300., 1200., 2e3, 5000.]
	c = [1520, 1500, 1515, 1495, 1545.]
	R = 250e3
	Z = z_c[end]
	ocn = AcousticPropagation.Medium(z_c, c, R)
	
	r₀ = 0.0
	z₀ = 20.0
	src = AcousticPropagation.Entity(r₀, z₀)
	
	bty = AcousticPropagation.Boundary(Z)
	
	θ_crit = acos(ocn.c(r₀, z₀)/ocn.c(r₀, Z))
	θ₀ = θ_crit*rand((0.5, 1.0))
	
	nothing
end

# ╔═╡ 57c41320-fde4-11ea-3fd8-351192415917
ray = AcousticPropagation.Ray(θ₀, src, ocn, bty);

# ╔═╡ b1c28750-fde7-11ea-24f0-23050e9d0d0e
plot(ray.Sol, vars = (1, 2),
	xaxis = "Range (m)",
	yaxis = ("Depth (m)", :flip))

# ╔═╡ 22d78b60-fde9-11ea-2a88-3118125cf30b
begin
	f = 200
	ω = 2π*f
end

# ╔═╡ ecf09052-fde8-11ea-27cf-c397d368a09c
begin
	A = 1
	p_beam(s) = A * sqrt(ray.c(s)/ray.r(s)/ray.q(s)) * exp(-im*ω)
	TL_beam(s) = -20log10(abs(p_beam(s)))
end

# ╔═╡ 54b58be0-fdea-11ea-356e-b9f30d0f15be
s = range(0, ray.S, length = 1000)

# ╔═╡ 4fcd84b0-fe27-11ea-29f2-07ff5129b488
begin
	r = R/100
	z = Z/2
end

# ╔═╡ 9e3552fe-fdee-11ea-1664-97194950ce10
fzero(s) = 2(ray.r(s) - r)*ray.∂r_∂s(s) + 2(ray.z(s) - z)*ray.∂z_∂s(s)

# ╔═╡ d5a98de0-fe27-11ea-0348-0f3eca4ef8ea
rts = roots(fzero, 0..10)

# ╔═╡ Cell order:
# ╟─34c9dff0-fdd8-11ea-383b-b3c3d5e3bbe8
# ╠═1968f0a2-fde4-11ea-3a5e-c1fc5176627f
# ╟─3e7e5a20-fdd9-11ea-3a3b-31fe9237e71e
# ╟─6edbdfb0-fddb-11ea-1b8d-3dd87aa01386
# ╟─d2c2a7f0-fde2-11ea-16ad-ab1114259f56
# ╟─fdf32220-fde1-11ea-25e6-9db949c15ec2
# ╟─75c3a120-fde3-11ea-1682-87e3dc7aee71
# ╠═73d6a8c0-fde4-11ea-237d-15e08ebdaa1c
# ╠═57c41320-fde4-11ea-3fd8-351192415917
# ╠═b1c28750-fde7-11ea-24f0-23050e9d0d0e
# ╠═22d78b60-fde9-11ea-2a88-3118125cf30b
# ╠═ecf09052-fde8-11ea-27cf-c397d368a09c
# ╠═54b58be0-fdea-11ea-356e-b9f30d0f15be
# ╠═9e3552fe-fdee-11ea-1664-97194950ce10
# ╠═4fcd84b0-fe27-11ea-29f2-07ff5129b488
# ╠═d5a98de0-fe27-11ea-0348-0f3eca4ef8ea
