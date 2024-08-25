abstract type OcnSon end

function Base.show(io::IO, ocnson::OcnSon)
    print(io, ocnson |> typeof, "(")
    properties = ocnson |> propertynames
    print.(io, ":", properties[1:end-1], ", ")
    print(io, ":", properties[end], ")")
end

Base.broadcastable(ocnson::OcnSon) = Ref(ocnson)

abstract type OcnSonFun <: OcnSon end

(ocnsonfun::OcnSonFun)(args...; kwargs...) = ocnsonfun.fun(args...; kwargs...)

function Base.show(io::IO, ocnson::OcnSonFun)
    type = typeof(ocnson).name |> string
    type = split(type, "(")[end]
    type = split(type, ".")[end]
    specific_type = split(type, ")", keepempty = false)[end]
    print(io, specific_type, "(")
    properties = ocnson |> propertynames
    print.(io, ":", properties[1:end-1], ", ")
    print(io, ":", properties[end], ")")
end