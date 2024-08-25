export BeamTrace

include("beam_trace/beam.jl")

dot(u, v) = u' * v

function itp_beams2grid(
    scen::Scenario,
    beams::AbstractVector{<:Beam},
    ranges::AbstractVector{<:AbstractFloat},
    depths::AbstractVector{<:AbstractFloat}
)
    Nx = length(ranges)
    Nz = length(depths)
    p = Matrix{ComplexF64}(undef, Nx, Nz)

    Ns = max(101, Nx ÷ 3)
    for beam in beams
        arc = range(0.0, beam.s_max, Ns)    
        c(s) = scen.env.ocn.cel(beam.x(s), beam.z(s))
        for i = eachindex(arc)[begin+1 : end]
            sᵢ₋₁, sᵢ = arc[i-1 : i]
            rᵢ₋₁, rᵢ = beam.x.([sᵢ₋₁, sᵢ])
            # zᵢ₋₁ = z(sᵢ₋₁)
            zᵢ = beam.z(sᵢ)
            # for (nr, r_grid) in enumerate(ranges)
            # 	if !(rᵢ₋₁ .≤ r_grid .< rᵢ)
            # 		continue
            # 	end
            for nr in findall(rᵢ₋₁ .≤ ranges .< rᵢ)
                r_grid = ranges[nr]
                for (nz, z_grid) in enumerate(depths)
                    x_rcv = [r_grid, z_grid]
                    # x_ray = [rᵢ₋₁, zᵢ₋₁]
                    x_ray = [rᵢ, zᵢ]
                    t_ray = c(sᵢ₋₁) * [beam.ξ(sᵢ₋₁), beam.ζ(sᵢ₋₁)]
                    t_ray /= dot(t_ray, t_ray) |> sqrt
                    n_ray = c(sᵢ₋₁) * [-beam.ζ(sᵢ₋₁), beam.ξ(sᵢ₋₁)]
                    n_ray /= dot(n_ray, n_ray) |> sqrt
                    s = dot(x_rcv - x_ray, t_ray)
                    n = dot(x_rcv - x_ray, n_ray) |> abs
                    p_add = beam.p(sᵢ₋₁ + s, n)
                    if !(isnan(p_add) || isinf(p_add))
                        p[nr, nz] += p_add
                    end
                end
            end
        end
    end
    return p
end

struct BeamTrace <: Propagation
    scen::Scenario
    beams::Vector{<:Beam}
    x::Vector{<:Float64}
    z::Vector{<:Float64}
    p::Array{ComplexF64, 2}
    PL::Array{Float64, 2}

    function BeamTrace(
        scen::Scenario,
        angles::AbstractVector{<:Real},
        ranges::AbstractVector{<:Real},
        depths::AbstractVector{<:Real}
    )
        δθ₀ = length(angles) == 1 ? 1.0 : angles |> diff |> mean
        beams = [Beam(scen, δθ₀, θ₀) for θ₀ in angles]
        p = itp_beams2grid(scen, beams, ranges, depths)
        PL = @. -20log10(p |> abs)

        new(scen, beams, ranges |> collect, depths |> collect, p, PL)
    end
end

Propagation(::Val{:beam_trace}, args...; kwargs...) = BeamTrace(args...; kwargs...)