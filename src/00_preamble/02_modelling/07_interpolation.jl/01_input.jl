abstract type SpatialInterpolation1D <: SpatialInterpolation end

struct RangeInterpolation <: SpatialInterpolation1D
    fcn::AbstractInterpolation
    F::Vector{Float64}
    r::Vector{Float64}

    function RangeInterpolation(model::Model{M},
        F::AbstractVector{<:Real},
        r::AbstractVector{<:Real}
    ) where {M}
        @assert r[begin] ≥ 0
        fcn = interpolation(model, F, r)
        new(fcn, F, r)
    end
end

listmodels(::Type{Model}, ::Type{<:RangeInterpolation}) = listmodels(Model, interpolator)

struct DepthInterpolation <: SpatialInterpolation1D
    fcn::AbstractInterpolation
    F::Vector{Float64}
    z::Vector{Float64}

    function DepthInterpolation(model::Model{M},
        F::AbstractVector{<:Real},
        z::AbstractVector{<:Real}
    ) where {M}
        fcn = interpolation(model, F, z)
        new(fcn, F, r)
    end
end

listmodels(::Type{Model}, ::Type{<:DepthInterpolation}) = listmodels(Model, interpolator)
