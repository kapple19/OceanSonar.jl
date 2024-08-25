module OceanSonar

using DifferentialEquations: ODEProblem, solve
using ForwardDiff: derivative
using Statistics: mean
import MakieCore
using Roots

abstract type OcnSon end
abstract type OcnSonOpt <: OcnSon end

function Base.show(io::IO, ocnson::OcnSon)
    print(ocnson |> typeof, "(")
    properties = ocnson |> propertynames
    for (n, property) = enumerate(properties)
        print(":", property)
        if n < length(properties)
            print(", ")
        end
    end
    println(")")
end

include("supplements.jl")
include("oceanography.jl")
include("acoustics.jl")

end # module OceanSonar