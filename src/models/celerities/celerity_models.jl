include("OceanCelerities.jl")
include("AtmosphereCelerities.jl")
include("SeabedCelerities.jl")
include("ShearSeabedCelerities.jl")

"""
`ocean_celerities::Vector{String}`

List of oceanic compressional celerity models.
"""
ocean_celerities = list_models(OceanCelerities)

"""
`atmosphere_celerities::Vector{String}`

List of atmospheric compressional celerity models.
"""
atmosphere_celerities = list_models(AtmosphereCelerities)

"""
`seabed_celerities::Vector{String}`

List of seabed compressional celerity models.
"""
seabed_celerities = list_models(SeabedCelerities)

function Structures.Celerity(model::String)
    model_symbol = Symbol(model)

    if model in ocean_celerities
        return getproperty(OceanCelerities, model_symbol)
    elseif model in atmosphere_celerities
        return getproperty(AtmosphereCelerities, model_symbol)
    elseif model in seabed_celerities
        return getproperty(SeabedCelerities, model_symbol)
    end

    error("Unrecognised compressional celerity model.")
end

"""
```
celerity
```
"""
function celerity(model::String, args...; kwargs...)
    cel = Structures.Celerity(model)
    cel(args...; kwargs...)
end

"""
`shear_seabed_celerities::Vector{String}`

List of shear seabed celerity models.
"""
shear_seabed_celerities = list_models(ShearSeabedCelerities)

"""
```
function ShearCelerity(model::String)
```
"""
function ShearCelerity(model::String)
    if model in seabed_celerities
        return getproperty(SeabedCelerities, Symbol(model))
    end
end

"""
`function shear_celerity(model::String, args...; kwargs...)`
"""
function shear_celerity(model::String, args...; kwargs...)
    cel = Structures.ShearCelerity(model)
    cel(args...; kwargs...)
end