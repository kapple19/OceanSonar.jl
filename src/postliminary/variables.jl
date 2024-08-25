name(type::Type{<:OcnSon}) = title_case(type |> string)

name(ocnson::OcnSon) = ocnson |> typeof |> name

name(type::Type{<:Propagation}) = "Propagation Loss"

# TODO: Supercede `unit` with a package like Unitful.jl.

unit(::Type{<:Boundary}) = "m"
unit(::Type{<:Celerity}) = "m/s"
unit(::Type{<:Density}) = "kg/m³"
unit(::Type{<:Propagation}) = "dB re m²"

unit(ocnson::OcnSon) = ocnson |> typeof |> unit

label(type::Type{<:OcnSon}) = name(type) * " (" * unit(type) * ")"
label(ocnson::OcnSon) = ocnson |> typeof |> label