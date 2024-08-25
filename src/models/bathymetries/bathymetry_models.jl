include("Bathymetries.jl")

"""
List of bathymetry models.
"""
bathymetries = list_models(Bathymetries)

function Structures.Bathymetry(model::String)
    !(model in bathymetries) && error("Unrecognised bathymetry model.")
    getproperty(Bathymetries, Symbol(model))
end

function bathymetry(model::String, args...; kwargs...)
    bty = Structures.Bathymetry(model)
    bty(args...; kwargs...)
end