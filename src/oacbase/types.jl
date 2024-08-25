abstract type Oac end

function Base.show(io::IO, oac::Oac)
	print(typeof(oac), ": {")
	for p in propertynames(oac)
		println()
		prop = getproperty(oac, (p))
		print(" ", p, ": ")
		if typeof(prop) in (Number, String)
			print(prop)
		else
			print(prop |> typeof)
		end
	end
	println()
	print("}")
end

# Exceptions
struct NotSorted <: Exception
	var
end
Base.showerror(io::IO, e::NotSorted) = print(io, e.var, " not sorted")

struct NotAllUnique <: Exception
	var
end
Base.showerror(io::IO, e::NotAllUnique) = print(io, e.var, " not all unique")