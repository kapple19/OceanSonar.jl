export get

# TODO: automate

get(med::Medium, ::Type{<:Celerity}) = med.cel
get(med::Medium, ::Type{<:Density}) = med.den

get(slc::Slice, ::Type{<:Altimetry}) = slc.ati
get(slc::Slice, ::Type{<:Bathymetry}) = slc.bty
get(slc::Slice, ::Type{<:OceanCelerity}) = get(slc.ocn, Celerity)
get(slc::Slice, ::Type{<:OceanDensity}) = get(slc.ocn, Density)

get(scen::Scenario, ::Type{<:Altimetry}) = get(scen.slc, Altimetry)
get(scen::Scenario, ::Type{<:Bathymetry}) = get(scen.slc, Bathymetry)
get(scen::Scenario, ::Type{<:OceanCelerity}) = get(scen.slc, OceanCelerity)
get(scen::Scenario, ::Type{<:OceanDensity}) = get(scen.slc, OceanDensity)

get(prop::Propagation, ::Type{<:Altimetry}) = get(prop.scen, Altimetry)
get(prop::Propagation, ::Type{<:Bathymetry}) = get(prop.scen, Bathymetry)
get(prop::Propagation, ::Type{<:OceanCelerity}) = get(prop.scen, OceanCelerity)
get(prop::Propagation, ::Type{<:OceanDensity}) = get(prop.scen, OceanDensity)