"Abstract supertype for `OceanSonar` types."
abstract type OcnSon end

function Base.show(io::IO, os::OcnSon)
	print(io, typeof(os), ": {")
	for p in propertynames(os)
		~isdefined(os, p) && continue
		println(io)
		prop = getproperty(os, (p))
		print(io, " ", p, ": ")
        if prop isa Function
            print(io, Function)
        elseif prop isa Union{Number, String}
			print(io, prop)
		else
			print(io, prop |> typeof)
		end
	end
	println(io)
	print(io, "}")
end