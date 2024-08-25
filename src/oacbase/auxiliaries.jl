function get_names(m::Module)
	m_string = string(m)
	n_period = findlast('.', m_string)
	m_symbol = isnothing(n_period) ? Symbol(m) : Symbol(m_string[n_period + 1 : end])
	all_names = names(m, all = true, imported = false)
	return [
		name
			for name in all_names
				if Base.isidentifier(name) && name ∉ (Symbol(m), m_symbol, :eval, :include)
	]
end

function export_all(m::Module)
	for n in get_names(m)
		@eval export $n
	end
end

function interp_vec_pair(
	x::Vector{<:Tx},
	y::Vector{<:Ty}
) where {Tx <: Number, Ty <: Number}
	y_interp = linear_interpolation(x, y,
		extrapolation_bc = Line()
	)
	y_fcn(x::Tx) = Ty(y_interp(x))
	return y_fcn
end

# function series125(N::Int)
# 	@assert N ≥ 1 "Input must be a positive integer."
# 	series = Int[]
# 	index = 1
# 	while isempty(series) || series[end] < N
# 		for n = [1, 2, 5]
# 			num = n * index
# 			if num > N
# 				return series
# 			else
# 				push!(series, num)
# 			end
# 		end
# 		index *= 10
# 	end
# 	series
# end

# export series125