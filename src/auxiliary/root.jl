"Generic supertype for many names defined by OceanSonar.jl"
abstract type OcnSon end

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

"Type for low-level model implementations."
abstract type OcnSonFunction <: OcnSon end

"Type for functor implementations."
abstract type OcnSonFunctor <: OcnSon end

"Type for container implementations."
abstract type OcnSonContainer <: OcnSon end

"Type for high-level container implementations"
abstract type OcnSonHybrid <: OcnSon end

(..)(lo, hi) = interval(lo, hi)

include("stringcases.jl")
include("modelling.jl")

uniquesort! = unique! ∘ sort!

include("interpolation.jl")