function show(io::IO, ocnson::OcnSon)
    print(io, ocnson |> typeof)
    properties = ocnson |> propertynames
    if !isempty(properties)
        print(io, "(")
        print.(io, ":", properties[1:end-1], ", ")
        print(io, ":", properties[end], ")")
    end
end

length(::OcnSon) = 1
iterate(ocnson::OcnSon, state = 1) = state > 1 ? nothing : (ocnson, state + 1)
