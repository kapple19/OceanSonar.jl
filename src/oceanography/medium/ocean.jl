export Ocean

"""
TODO.
"""
@kwdef mutable struct Ocean <: Medium
    model::Val = Val(Symbol())
    cel::OceanCelerity = OceanCelerity()
end

Ocean(model::Val{:homogeneous}) = Ocean(
    model = model,
    cel = OceanCelerity(:homogeneous |> Val)
)

Ocean(model::Val{:munk_profile}) = Ocean(
    model = model,
    cel = OceanCelerity(:munk |> Val)
)

Ocean(model::Val{:index_squared_profile}) = Ocean(
    model = model,
    cel = OceanCelerity(:index_squared |> Val)
)

@parse_models Ocean