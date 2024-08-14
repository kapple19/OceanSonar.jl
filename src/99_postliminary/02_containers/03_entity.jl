export Entity

abstract type EmissionType end

struct NoiseOnly <: EmissionType end
struct Signaling <: EmissionType end

abstract type AbstractEntity <: ModellingContainer end

struct AbsentEntity <: AbstractEntity end

@kwdef mutable struct Entity{ET <: EmissionType} <: AbstractEntity
    SL::Float32 = NaN32
    NL::Float32 = NaN32
    pos::RectangularCoordinate{DownwardDepth} = RectangularCoordinate{DownwardDepth}(x = 0, y = 0, z = 0)
end

# Entity{NoiseOnly}(;
#     SL = NaN32,
#     NL::Real,
#     pos::RectangularCoordinate{DownwardDepth}
# ) = Entity{NoiseOnly}(SL = SL, NL = NL, pos = pos)

# Entity{Signaling}(;
#     SL::Real,
#     NL::Real = 0,
#     pos::RectangularCoordinate{DownwardDepth}
# ) = Entity{Signaling}(SL = SL, NL = NL, pos = pos)

# function Entity{ETnew <: EmissionType}(ent::Entity{ETold}) where {ETold <: EmissionType}
#     Entity{ETnew}(
#         field => getproperty(ent, field)
#         for field in fieldnames(Entity)
#     )
# end
