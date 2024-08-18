# (osm::OceanSonarModel)(M::Union{Symbol, <:AbstractString}, args...; kw...) = osm(Model(M), args...; kw...)

(osm::ModelFunction)(M::Union{Symbol, <:AbstractString}, args...; kw...) = osm(Model(M), args...; kw...)

(OSM::Type{<:ModelFunctor})(M::Union{Symbol, <:AbstractString}, args...; kw...) = OSM(Model(M), args...; kw...)

(OSM::Type{<:ModelContainer})(M::Union{Symbol, <:AbstractString}, args...; kw...) = OSM(Model(M), args...; kw...)

(OSM::Type{<:ModelComputation})(M::Union{Symbol, <:AbstractString}, args...; kw...) = OSM(Model(M), args...; kw...)
