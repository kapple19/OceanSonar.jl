abstract type SpatialData end

abstract type SpatialData2D <: SpatialData end
abstract type SpatialData3D <: SpatialData end

struct SpatialDataCylindrical3D <: SpatialData3D
    r::Vector{Float64}
    z::Vector{Float64}
    θ::Vector{Float64}
    F::Array{Float64, 3}
    itp::AbstractInterpolation
end

struct SpatialDataCylindrical2D <: SpatialData2D
    r
    z
end

function SpatialDataCylindrical3D()

end

struct SoundSpeedProfileData
    r::Vector{Float64}
    z::Vector{Float64}
    θ::Vector{Float64}
    c::Array{Float64, 3}
    itp::AbstractInterpolation
end

sound_speed_profile_data = Dict{Symbol, SpatialData}

function sound_speed_profile(model, z; pars...)

end

struct SoundSpeedProfile <: Function
    model::Model{M} where {M}
    ranges::Vector{Float64}
    depths::Vector{Float64}
    azimuths::Vector{Float64}
    sound_speeds::Array{Float64, 3}
    itp::AbstractInterpolation

    function SoundSpeedProfile(
        model::Model{M},
        ranges::Vector{Float64},
        depths::Vector{Float64},
        azimuths::Vector{Float64},
        sound_speeds::Array{Float64, 3},
        itp::AbstractInterpolation,
    ) where {M}
        for r in ranges, z in depths, θ in azimuths
            @assert itp(r, z, θ) isa Real
        end
        new(model, ranges, depths, azimuths, sound_speeds, itp)
    end
end

function SoundSpeedProfile()

end

## Usage
sound_speed_profile(:Munk, z; ϵ)
c = SoundSpeedProfile(:Munk; ϵ)
c.itp