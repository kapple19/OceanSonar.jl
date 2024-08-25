export Ocean

"""
TODO.
"""
@kwdef mutable struct Ocean <: Medium
    model::Val = Val(Symbol())
    cel::OceanCelerity = OceanCelerity()
    den::OceanDensity = OceanDensity()
    atn::OceanAttenuation = OceanAttenuation()
end

Ocean(model::Val{:homogeneous}) = Ocean(
    model = model,
    cel = OceanCelerity(:homogeneous)
)

Ocean(model::Val{:munk_profile}) = Ocean(
    model = model,
    cel = OceanCelerity(:munk)
)

Ocean(model::Val{:index_squared_profile}) = Ocean(
    model = model,
    cel = OceanCelerity(:index_squared)
)

@parse_models Ocean