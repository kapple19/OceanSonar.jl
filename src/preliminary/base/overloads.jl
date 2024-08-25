show(io::IO, ocnson::OcnSon) = show(io, ocnson |> typeof)
length(::OcnSon) = 1
iterate(ocnson::OcnSon, state = 1) = state > 1 ? nothing : (ocnson, state + 1)