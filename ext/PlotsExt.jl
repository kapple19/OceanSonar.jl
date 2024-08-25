module PlotsExt

using OceanSonar
using Plots

@recipe function _(cel::Celerity)
    seriestype := :path
    linecolor --> :blue
    yflip := true
    legend --> false
    xguide --> "Celerity [m/s]"
    yguide --> "Depth [m]"

    x_lo, x_hi = extrema(cel.x_imp)
    z_lo, z_hi = extrema(cel.z_imp)
    
    range_independent = isinf(x_lo) && isinf(x_hi)
    depth_independent = isinf(z_lo) && isinf(z_hi)

    return if range_independent
        z = if depth_independent
            range(0.0, 100.0, 2)
        else
            range(z_lo, z_hi, 101)
        end
        cel.(0.0, z), z
    else
        if depth_independent
            x = range(x_lo, x_hi)
            x, cel.(x, 0.0)
        else
            error("Range and depth dependence celerity plots currently unsupported.")
        end
    end
end

@recipe function _(rays::AbstractVector{<:Ray})
    seriestype := :path
    linecolor --> :blue
    yflip := true
    legend --> false
    xguide --> "Range [m]"
    yguide --> "Depth [m]"

    xs = Vector{Float64}[]
    zs = Vector{Float64}[]

    for ray = rays
        s = range(extrema(ray.s_imp)..., 101)

        push!(xs, ray.x.(s))
        push!(zs, ray.z.(s))
    end

    xs, zs
end

@recipe function _(ray::Ray)
    [ray]
end

@recipe function _(trc::Trace)
    rays = if isdefined(trc, :rays)
        trc.rays
    elseif isdefined(trc, :beams)
        [beam.ray for beam in trc.beams]
    else
        error("Unrecognised `Trace` instance for plotting.")
    end

    rays
end

end