export trace_gridder!
export trace_gridder

function trace_gridder!(model::Val,
    p::AbstractMatrix{<:Complex},
    beams::Vector{Beam},
    scen::Scenario;
    ranges::AbstractVector{<:Real} = default_ranges(scen),
    depths::AbstractVector{<:Real} = default_depths(scen)
)
    trace_gridder!(model, p, beams;
        ranges = ranges,
        depths = depths
    )
end

@parse_models_w_args_kwargs trace_gridder!

function trace_gridder(model::Val,
    beams::Vector{Beam};
    ranges::AbstractVector{<:Real},
    depths::AbstractVector{<:Real}
)
    Nx = length(ranges)
    Nz = length(depths)
    p = fill(ComplexF64(0.0), (Nx, Nz))

    trace_gridder!(model, p, beams;
        ranges = ranges,
        depths = depths
    )
end

function trace_gridder(model::Val,
    beams::Vector{Beam},
    scen::Scenario;
    ranges::AbstractVector{<:Real} = default_ranges(scen),
    depths::AbstractVector{<:Real} = default_depths(scen)
)
    trace_gridder(model, beams;
        ranges = ranges,
        depths = depths
    )
end

@parse_models_w_args_kwargs trace_gridder

## Models

function trace_gridder!(::Val{:segments},
    p::AbstractMatrix{<:Complex},
    beams::AbstractVector{<:Beam};
    ranges::AbstractVector{<:Real},
    depths::AbstractVector{<:Real},
)
    Nx = length(ranges)

    Xrcv = fill(NaN, 2)
    Xray = fill(NaN, 2)
    Tray = fill(NaN, 2)
    Nray = fill(NaN, 2)
    dX = fill(NaN, 2)

    for beam in beams
        s = [
            range(0.0, beam.s_max, max(101, Nx ÷ 3));
            beam.s_rfl;
            beam.s_hrz
        ] |> uniquesort!
        # s = range(0.0, beam.s_max, max(101, Nx ÷ 3))

        for i = eachindex(s)[begin+1 : end]
            sᵢ₋₁ = s[i-1]
            sᵢ = s[i]
            xᵢ₋₁ = beam.x(sᵢ₋₁)
            xᵢ = beam.x(sᵢ)
            zᵢ = beam.z(sᵢ)
            ξᵢ₋₁ = beam.ξ(sᵢ₋₁)
            ζᵢ₋₁ = beam.ζ(sᵢ₋₁)
            cᵢ₋₁ = beam.c(sᵢ₋₁)

            for nx in findall(xᵢ₋₁ .≤ ranges .< xᵢ)
                x_grid = ranges[nx]
                @views for (nz, z_grid) in enumerate(depths)
                    Xrcv[1] = x_grid
                    Xrcv[2] = z_grid
                    Xray[1] = xᵢ
                    Xray[2] = zᵢ
                    Tray[1] = cᵢ₋₁ * ξᵢ₋₁
                    Tray[2] = cᵢ₋₁ * ζᵢ₋₁
                    Nray[1] = cᵢ₋₁ * -ζᵢ₋₁
                    Nray[2] = cᵢ₋₁ * ξᵢ₋₁
                    dX[1] = Xrcv[1] - Xray[1]
                    dX[2] = Xrcv[2] - Xray[2]
                    arc = sᵢ₋₁ + dot(dX, Tray)
                    nrm = dot(dX, Nray) |> abs
                    p̂ = beam(arc, nrm)
                    if !isnan(p̂) && !isinf(p̂)
                        p[nx, nz] = p[nx, nz] + p̂
                    end
                end
            end
        end
    end

    return p
end