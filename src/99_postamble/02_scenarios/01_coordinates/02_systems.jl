export NoCoordinates
export Rectangular
export Cylindrical
export Spherical

abstract type CoordinateSystem end

NothingOrReal = Union{Nothing, <:Real}

struct NoCoordinates <: CoordinateSystem end

for (System, axes) in (
    :Rectangular => (:x, :y, :z),
    :Cylindrical => (:r, :θ, :z),
    :Spherical => (:ρ, :θ, :φ),
)
    (axisa, axisb, axisc) = axes
    (TypeA, TypeB, TypeC) = @. Symbol("Type" * String(axes))
    @eval begin
        mutable struct $System{
            H <: Handedness,
            $TypeA <: NothingOrReal,
            $TypeB <: NothingOrReal,
            $TypeC <: NothingOrReal
        } <: ModelContainer
            $axisa :: $TypeA
            $axisb :: $TypeB
            $axisc :: $TypeC
        end
        
        function $System{H}(
            $axisa :: NothingOrReal,
            $axisb :: NothingOrReal,
            $axisc :: NothingOrReal,
        ) where {H <: Handedness}
            $System{
                H,
                typeof($axisa),
                typeof($axisb),
                typeof($axisc)
            }(
                $axisa,
                $axisb,
                $axisc,
            )
        end
        
        function $System{H}(;
            $axisa :: NothingOrReal = nothing,
            $axisb :: NothingOrReal = nothing,
            $axisc :: NothingOrReal = nothing,
        ) where {H <: Handedness}
            $System{H}(
                $axisa,
                $axisb,
                $axisc,
            )
        end
    end
end
