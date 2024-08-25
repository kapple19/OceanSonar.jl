### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 29b26c10-fd63-11ea-19d9-51bbbdf5e6f6
using LinearAlgebra

# ╔═╡ 15626ee0-fd68-11ea-2c83-2dc85ba373e7
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ 973991a0-fd68-11ea-27c8-61246753b4b3
ingredients("../AcousticPropagation.jl")

# ╔═╡ ce78547e-fd68-11ea-3d71-61ec6c934761
t_inc = [0.0014855627054164151, 0.003713906763541037]

# ╔═╡ e64e2ad0-fd68-11ea-040d-6907d34eca35
t_bnd = [1.0, 0.6770329614269008]

# ╔═╡ ef543200-fd68-11ea-1c37-c158193f71be
n_bnd = [-t_bnd[2], t_bnd[1]]

# ╔═╡ 0bf32920-fd69-11ea-293c-4949b8fee869
t_rfl = t_inc - 2LinearAlgebra.dot(t_inc, n_bnd)*n_bnd

# ╔═╡ Cell order:
# ╠═29b26c10-fd63-11ea-19d9-51bbbdf5e6f6
# ╠═15626ee0-fd68-11ea-2c83-2dc85ba373e7
# ╠═973991a0-fd68-11ea-27c8-61246753b4b3
# ╠═ce78547e-fd68-11ea-3d71-61ec6c934761
# ╠═e64e2ad0-fd68-11ea-040d-6907d34eca35
# ╠═ef543200-fd68-11ea-1c37-c158193f71be
# ╠═0bf32920-fd69-11ea-293c-4949b8fee869
