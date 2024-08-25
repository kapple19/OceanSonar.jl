export default_ranges
export default_depths
export default_angles
export steepest_angle
export critical_angle

include("beam.jl")

default_ranges(scen, N = 251) = range(0, scen.x, N)
default_depths(scen, N = 201) = range(depth_extrema(scen)..., N)

function steepest_angle(scen)
    dz = scen |> depth_extrema |> reverse |> splat(-)
    atan(dz, scen.x / 20) |> abs
end

function default_angles(
    scen::Scenario;
    θ_max::Real = steepest_angle(scen),
    N::Integer = 101
)
    return θ_max * if scen.z == scen.env.ati(0)
        range(0, 1, N)[2:end]
    elseif scen.z == scen.env.bty(0)
        range(-1, 0, N+1)[1:end-1]
    else
        range(-1, 1, N)
    end
end

function critical_angle(scen::Scenario; x::Real = 0, z::Real = 0)
    acos(scen.env.ocn.cel(0, scen.z) / scen.env.ocn.cel(x, z))
end

"""
TODO.
"""
struct Trace <: Propagation
    scen::Scenario
    beams::Vector{<:Beam}
    x::Vector{<:Float64}
    z::Vector{<:Float64}
    p::Array{<:ComplexF64, 2}
    PL::Array{<:Float64, 2}

    function Trace(scen::Scenario;
        ranges::AbstractVector{<:AbstractFloat} = default_ranges(scen),
        depths::AbstractVector{<:AbstractFloat} = default_depths(scen),
        angles::AbstractVector{<:AbstractFloat} = default_angles(scen)
    )
        c_func = scen.env.ocn.cel
        ∂c_∂x_func(x::Real, z::Real) = derivative(x -> c_func(x, z), x)
        ∂c_∂z_func(x::Real, z::Real) = derivative(z -> c_func(x, z), z)
        ∂²c_∂x²_func(x::Real, z::Real) = derivative(x -> ∂c_∂x_func(x, z), x)
        ∂²c_∂z²_func(x::Real, z::Real) = derivative(z -> ∂c_∂z_func(x, z), z)
        ∂²c_∂x∂z_func(x::Real, z::Real) = derivative(z -> ∂c_∂x_func(x, z), z)
        ∂²c_∂n²_func(x::Real, z::Real, ξ::Real, ζ::Real) = c_func(x, z)^2 * (
            ∂²c_∂x²_func(x, z) * ζ^2
            - 2∂²c_∂x∂z_func(x, z) * ξ * ζ
            + ∂²c_∂z²_func(x, z) * ξ^2
        )

        δθ₀ = length(angles) == 1 ? 1.0 : angles |> diff |> mean

        function trace!(du, u, _, s)
            x, z, ξ, ζ, pRe, pIm, qRe, qIm = u

            c = c_func(x, z)
            c² = c^2
            ∂c_∂x = ∂c_∂x_func(x, z)
            ∂c_∂z = ∂c_∂z_func(x, z)
            ∂²c_∂n² = ∂²c_∂n²_func(x, z, ξ, ζ)

            du[1] = dx_ds = c * ξ
            du[2] = dz_ds = c * ζ
            du[3] = dξ_ds = -∂c_∂x / c²
            du[4] = dζ_ds = -∂c_∂z / c²
            du[5] = dτ_ds = 1 / c
            du[6] = dpRe_ds = -∂²c_∂n² * qRe / c²
            du[7] = dpIm_ds = -∂²c_∂n² * qIm / c²
            du[8] = dqRe_ds = c * pRe
            du[8] = dqIm_ds = c * pIm
        end

        x₀::Float64 = 0.0
        z₀::Float64 = scen.z
        c₀::Float64 = c_func(x₀, z₀)
        τ₀::Float64 = 0.0
        λ₀::Float64 = c₀ / scen.f
        W₀::Float64 = 30λ₀
        p₀::ComplexF64 = 1.0 + 0.0im
        q₀::ComplexF64 = 0.0 + im * pi * scen.f * W₀^2

        Nx = length(ranges)
        Nz = length(depths)
        pressure = fill(ComplexF64(0.0), (Nx, Nz))

        beams = Beam[]

        for θ₀ in angles
            ξ₀ = cos(θ₀) / c₀
            ζ₀ = sin(θ₀) / c₀
            
            u₀ = [x₀, z₀, ξ₀, ζ₀, τ₀, reim(p₀)..., reim(q₀)...]

            s_span = (0.0, 1e6)

            s_rfl = Float64[]
            R_rfl = ComplexF64[]

            function reflect!(ntg, bnd::Boundary)
                x, z, ξ, ζ = ntg.u[1:4]
                c = c_func(x, z)

                θ_bnd_deg = derivative(bnd, x) |> atand
                θ_inc_deg = atand(ζ, ξ)
                θ_rfl_deg = reflection_angle_degrees(θ_bnd_deg, θ_inc_deg)

                push!(s_rfl, ntg.t)

                ntg.u[3] = cosd(θ_rfl_deg) / c
                ntg.u[4] = sind(θ_rfl_deg) / c

                nothing
            end

            cb_rng = ContinuousCallback(
                (x, _, _) -> x[1] - scen.x,
                terminate!
            )

            cb_ati = ContinuousCallback(
                (x, _, ntg) -> x[2] - scen.env.ati(x[1]),
                ntg -> reflect!(ntg, scen.env.ati)
            )

            cb_bty = ContinuousCallback(
                (x, _, ntg) -> x[2] - scen.env.bty(x[1]),
                ntg -> reflect!(ntg, scen.env.bty)
            )

            cb = CallbackSet(cb_rng, cb_ati, cb_bty)

            prob = ODEProblem(trace!, u₀, s_span)
            sol = solve(prob, Tsit5(), callback = cb)

            s_max = sol.t[end]
            # x(s) = sol(s, idxs = 1)
            # z(s) = sol(s, idxs = 2)
            # ξ(s) = sol(s, idxs = 3)
            # ζ(s) = sol(s, idxs = 4)
            # τ(s) = sol(s, idxs = 5)
            # p(s) = sol(s, idxs = 6) + im * sol(s, idxs = 7)
            # q(s) = sol(s, idxs = 8) + im * sol(s, idxs = 9)
            x1 = Float64[0]
            z1 = Float64[0]
            ξ1 = Float64[0]
            ζ1 = Float64[0]
            τ1 = Float64[0]
            pRe1 = Float64[0]
            pIm1 = Float64[0]
            qRe1 = Float64[0]
            qIm1 = Float64[0]
            x!(s) = sol(x1, s, idxs = 1)
            z!(s) = sol(z1, s, idxs = 2)
            ξ!(s) = sol(ξ1, s, idxs = 3)
            ζ!(s) = sol(ζ1, s, idxs = 4)
            τ!(s) = sol(τ1, s, idxs = 5)
            pRe!(s) = sol(pRe1, s, idxs = 6)
            pIm!(s) = sol(pIm1, s, idxs = 7)
            qRe!(s) = sol(qRe1, s, idxs = 8)
            qIm!(s) = sol(qIm1, s, idxs = 9)
            
            ω = 2π * scen.f
            miω = -im * ω
            c1 = Float64[0.0]
            function c_func!(c1::Vector{<:Real}, x::Real, z::Real)
                c1[1] = c_func(x, z)
            end

            function beam_pressure(s::Real, n::Real)
                x!(s)
                !(0 < s < s_max) && return ComplexF64(0.0)
                x1[1] < 0 && return ComplexF64(0.0)
                
                qRe!(s)
                qIm!(s)
                pRe!(s)
                qRe!(s)
                q1 = qRe1[1] + im * qIm1[1]
                c_func!(c1, x1[1], z!(s)[1])
                sqrt_arg = c1[1] / (x1[1] * q1)
                exp_arg = miω * (τ!(s)[1] + (pRe1[1] + pIm1[1]) / 2q1 * n^2)
                A = δθ₀ / c₀ * sqrt(
                    q₀ * scen.f * cos(θ₀)
                ) * exp(im * π / 4)
                return A * sqrt(sqrt_arg) * exp(exp_arg) ::ComplexF64
            end

            function beam_pressure!(pressure_matrix::Matrix{<:Complex},
                nx::Int, nz::Int,
                s::Real, n::Real
            )
                p_add = beam_pressure(s, n)

                if !(isnan(p_add) || isinf(p_add))
                    pressure_matrix[nx, nz] += p_add
                end

                nothing
            end

            function populate_pressure!(pressure)
                Xrcv = Float64[0, 0]
                Xray = Float64[0, 0]
                Tray = Float64[0, 0]
                Nray = Float64[0, 0]
                arc = Float64[0]
                nrm = Float64[0]
                dX = Float64[0, 0]
                
                s = range(0.0, s_max, max(101, Nx ÷ 3))
                for i = eachindex(s)[begin+1 : end]::UnitRange{<:Int}
                    xᵢ₋₁ = x!(s[i-1])[1]
                    zᵢ = z!(s[i])[1]
                    xᵢ = x!(s[i])[1]
                    zᵢ₋₁ = z!(s[i-1])[1]
                    ξᵢ₋₁ = ξ!(s[i-1])[1]
                    ζᵢ₋₁ = ζ!(s[i-1])[1]
                    cᵢ₋₁ = c_func(xᵢ₋₁, zᵢ₋₁)
                    for nx in findall(xᵢ₋₁ .≤ ranges .< xᵢ)::Vector{<:Int}
                        x_grid = ranges[nx]
                        for (nz, z_grid) in enumerate(depths)
                            Xrcv[1] = x_grid
                            Xrcv[2] = z_grid
                            Xray[1] = xᵢ
                            Xray[2] = zᵢ
                            Tray[1] = cᵢ₋₁ * ξᵢ₋₁
                            Tray[2] = cᵢ₋₁ * ζᵢ₋₁
                            # Tray /= dot(Tray, Tray) |> sqrt
                            Nray[1] = cᵢ₋₁ * -ζᵢ₋₁
                            Nray[2] = cᵢ₋₁ * ξᵢ₋₁
                            # Nray /= dot(Nray, Nray) |> sqrt
                            dX[1] = Xrcv[1] - Xray[1]
                            dX[2] = Xrcv[2] - Xray[2]
                            arc[1] = s[i-1] + dot(dX, Tray)
                            nrm[1] = dot(dX, Nray) |> abs
                            beam_pressure!(pressure, nx, nz, arc[1], nrm[1])
                        end
                    end
                end
            end

            populate_pressure!(pressure)

            x(s) = sol(s, idxs = 1)
            z(s) = sol(s, idxs = 2)
            beam = Beam(s_max, s_rfl, x, z, beam_pressure)
            push!(beams, beam)
        end
        PL = @. -20log10(pressure |> abs)
        PL = max.(PL, 0.0)
        PL = min.(PL, 100.0)

        return new(scen, beams, ranges |> collect, depths |> collect, pressure, PL)
    end
end

"""
TODO.
"""
Propagation(::Val{:trace}, args...; kwargs...) = Trace(args...; kwargs...)