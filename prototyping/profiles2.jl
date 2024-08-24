## Sound Speed Profile Data Storage Mechanism
using DataInterpolations

## Modelling
struct Model{M} end

## Interpolation
Interpolation(::Model{:Linear}, args...; extrapolate = true, kws...) = LinearInterpolation(args...; extrapolate = extrapolate, kws...)

## Data
abstract type SpatialData end

(data::SpatialData)(args::Real...) = data.fcn(args::Real...)

abstract type SpatialData1D <: SpatialData end
abstract type SpatialData2D <: SpatialData end
abstract type SpatialData3D <: SpatialData end

struct SpatialData1D_DepthProfile <: SpatialData1D
    fcn::AbstractInterpolation
    z::Vector{Float64}
    F::Vector{Float64}

    function SpatialData1D_DepthProfile(model::Model, z::AbstractVector{<:Real}, F::AbstractVector{<:Real})
        @assert issorted(z)
        @assert (F, z) .|> length |> isequal
        fcn = Interpolation(model, F, z)
        new(fcn, F, z)
    end
end

struct SpatialData2D_DepthProfiles_Ranges <: SpatialData2D
    fcn::Function
    r::Vector{Float64}
    zF::Vector{SpatialData1D_DepthProfile}

    function SpatialData2D_DepthProfiles_Ranges{}(
        model::Model,
        r::AbstractVector{<:Real},
        zF::AbstractVector{<:SpatialData1D_DepthProfile}
    ) where {N}
        @assert issorted(r)
        @assert (zF, r) .|> length |> isequal
        Fz_data = [SpatialData1D_DepthProfile(depth_model, zF_...) for zF_ in zF]
        append = r[end] |> isfinite
        r_vals = copy(r)
        if append
            push!(r_vals, Inf)
        end

        function fcn(r_::Real, z_::Real)
            @assert 0 ≤ r_
            F_vals = [Fz_data_(z_) for Fz_data_ in Fz_data] # can optimize this to just the surrounding `r_` profiles.
            if append
                push!(F_vals, F_vals[end])
            end
            itp = Interpolation(range_model, F_vals, r_) # needs to construct a new interpolation object for each call?!
            return itp(r_)
        end
        new(fcn, r, Fz_data)
    end
end

function SpatialData2D_DepthProfiles_Ranges(
    range_model::Model,
    depth_model::Model,
    r::AbstractVector{<:Real},
    z::AbstractVector{<:Real},
    F::AbstractMatrix{<:Real},
)
    SpatialData2D_DepthProfiles_Ranges(
        range_model, depth_model,
        r,
        (
            (z, F[:, nr])
            for nr in eachindex(r)
        )
    )
end

struct SpatialData3D_DepthProfiles_Ranges_Azimuths <: SpatialData3D
    fcn::Function
    θ::AbstractVector{<:Real}
    rzF::Vector{SpatialData2D_RangeDepth}

    function SpatialData3D_DepthProfiles_Ranges_Azimuths(
        range_model::Model,
        depth_model::Model,
        azimuth_model::Model,
        θ::AbstractVector{<:Real},
        rzF::AbstractVector{<:Tuple}
    )
        
    end
end

## Usage

