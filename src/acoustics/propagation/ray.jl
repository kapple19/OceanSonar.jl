export Ray
export RayModel

function trace!(du, u, p, s, cel_fcn::Function)
    ∂c_∂x(x, z) = derivative(x -> cel_fcn(x, z), x)
    ∂c_∂z(x, z) = derivative(z -> cel_fcn(x, z), z)

    τ, x, z, ξ, ζ, p_re, p_im, q_re, q_im = u
    c = cel_fcn(x, z)
    c² = c^2
    ∂²c_∂x² = derivative(x -> ∂c_∂x(x, z), x)
    ∂²c_∂z² = derivative(z -> ∂c_∂z(x, z), z)
    ∂²c_∂x∂z = derivative(z -> ∂c_∂x(x, z), z)

    # Equation 3.62 of Jensen, et al (2011)
    cnn = c² * (
        ∂²c_∂x² * ζ^2
        - 2∂²c_∂x∂z * ξ * ζ
        + ∂²c_∂z² * ξ^2
    )

    # Equation 3.31 of Jensen, et al (2011)
    du[1] = dτ_ds = 1 / c

    # Equations 3.23-24 of Jensen, et al (2011)
    du[2] = dx_ds = c * ξ
    du[3] = dz_ds = c * ζ
    du[4] = dξ_ds = -∂c_∂x(x, z) / c²
    du[5] = dζ_ds = -∂c_∂z(x, z) / c²

    # Equation 3.58 of Jensen, et al (2011)
    du[6] = dp_re_ds = -q_re * cnn / c^2
    du[7] = dp_im_ds = -q_im * cnn / c^2
    du[8] = dq_re_ds = p_re * c
    du[9] = dq_im_ds = p_im * c
end

struct Ray <: OcnSon
    s_max

    τ
    x
    z
    ξ
    ζ
    p
    q
    c

    A
    W
    φ
    P

    point
    gradient
    tangent
    normal

    function Ray(scen::Scenario, θ₀::Real, δθ₀::Real, f::Real)
        c(x, z) = scen.env.ocn.cel.fun(x, z)

        trace_local!(du, u, p, s) = trace!(du, u, p, s, c)

        # Jensen, et al (2011)
        τ₀ = 0.0 # Eqn 3.32
        x₀ = scen.x # Eqn 3.27
        z₀ = scen.z # Eqn 3.28
        c₀ = c(x₀, z₀)
        ξ₀ = cos(θ₀) / c₀ # Eqn 3.27
        ζ₀ = sin(θ₀) / c₀ # Eqn 3.28
        p₀ = 1 / c₀ # Eqn 3.63
        q₀ = 0.0 # Eqn 3.63
        u₀ = [τ₀, x₀, z₀, ξ₀, ζ₀, real(p₀), imag(p₀), real(q₀), imag(q₀)]

        # TODO: Terminating callback for max length of s.
        # s_span = [0.0, 300e3] # munk profile
        s_span = [0, 3.7303e3] # n²-linear profile

        prob = ODEProblem(trace_local!, u₀, s_span)
        sol = solve(prob)

        τ(s) = sol(s, idxs = 1)
        x(s) = sol(s, idxs = 2)
        z(s) = sol(s, idxs = 3)
        ξ(s) = sol(s, idxs = 4)
        ζ(s) = sol(s, idxs = 5)
        p(s) = sol(s, idxs = 6) + im * sol(s, idxs = 7)
        q(s) = sol(s, idxs = 8) + im * sol(s, idxs = 9)
        c(s) = c(x(s), z(s))

        # Note: The dynamic ray initial conditions (p₀, q₀) determine the ray amplitude equation for A(s).
        # See section 3.3.5.1 of Jensen, et al (2011).
        # 
        # Used in tandem with geometric beam tracing.
        # The spacing δθ₀ must be accurately and consistently the difference between launch ray angles.
        # See section 3.3.5.5 of Jensen, et al (2011).

        # Equation 3.65 of Jensen, et al (2011).
        function A(s)
            (
                (
                    c(s) * cos(θ₀) / (
                        x(s) * c₀ * q(s)
                    )
                ) |> abs |> sqrt
            ) / 4π
        end

        # Equation 3.74 of Jensen, et al (2011).
        W(s::Real) = abs(q(s) * δθ₀)

        # Equation 3.73 of Jensen, et al (2011).
        φ(s::Real, n::Real) = abs(n) > W(s) ? 0 : (W(s) - n) / W(s)

        # Equation 3.72 of Jensen, et al (2011).
        ω = 2π * f
        P(s::Real, n::Real) = A(s) * φ(s, n) * exp(im * ω * τ(s))

        s_max = maximum(sol.t)

        point(s) = [x(s), z(s)]
        gradient(s) = ζ(s) / ξ(s)
        tangent(s) = [ξ(s), ζ(s)] / √(ξ(s)^2 + ζ(s)^2)
        normal(s) = [-ζ(s), ξ(s)] / √(ξ(s)^2 + ζ(s)^2)

        new(
            s_max,
            τ,
            x,
            z,
            ξ,
            ζ,
            p,
            q,
            c,
            A,
            W,
            φ,
            P,
            point,
            gradient,
            tangent,
            normal
        )
    end
end

function MakieCore.convert_arguments(plot_type::MakieCore.PointBased, ray::Ray)
    s_vec = range(0, ray.s_max, 301)
    MakieCore.convert_arguments(plot_type, ray.x.(s_vec), ray.z.(s_vec))
end

function default_launch_angles(scen::Scenario)
    atan(1e3 / 10e3) * range(-1, 1, 7) # for Munk profile
end

# function map_beams_to_grid(
#     rays::AbstractVector{<:Ray},
#     x_vec::AbstractVector{<:Real},
#     z_vec::AbstractVector{<:Real}
# )
#     p = zeros(ComplexF64, length(x_vec), length(z_vec))
#     for ray in rays
#         s_vec = range(0, ray.s_max, 201)
#         for (i, s) in enumerate(s_vec[1:end-1])
#             ray_arc_segment = s_vec[i:i+1]
#             xlo, xhi = ray.x.(ray_arc_segment) |> extrema
            
#             # TODO: Change < to ≤ on last loop.
#             for nx in [nx for nx in eachindex(x_vec) if xlo ≤ x_vec[nx] < xhi]
#                 @show x = x_vec[nx]
#                 for (nz, z) in enumerate(z_vec)
#                     @show z
#                     rcv_point = [x, z]

#                     displacement_transposed = (rcv_point - ray.point(s))'
#                     s_point = displacement_transposed * ray.tangent(s)
#                     n_point = abs(displacement_transposed * ray.normal(s))

#                     p_add = ray.P(s_point, n_point)

#                     @show n_point
#                     @show p_add

#                     if !isnan(p_add)
#                         # @show -20log10(p_add |> abs)
#                         p[nx, nz] += p_add
#                     end
#                 end
#             end
#         end
#     end
#     return p
# end

dot(u::AbstractVector, v::AbstractVector) = u' * v

function map_beams_to_grid(
    rays::AbstractVector{<:Ray},
    x_vec::AbstractVector{<:Real},
    z_vec::AbstractVector{<:Real}
)
    pressure = zeros(ComplexF64, length(x_vec), length(z_vec))
    for ray in rays
        arc = range(0.0, ray.s_max, max(101, floor(length(x_vec)/3) |> Int))
        for i = eachindex(arc)[begin+1 : end]
            sᵢ₋₁, sᵢ = arc[i-1 : i]
            rᵢ₋₁, rᵢ = ray.x.([sᵢ₋₁, sᵢ])
            # zᵢ₋₁ = z(sᵢ₋₁)
            zᵢ = ray.z(sᵢ)
            # for (nr, r_grid) in enumerate(ranges)
            # 	if !(rᵢ₋₁ .≤ r_grid .< rᵢ)
            # 		continue
            # 	end
            for nr in findall(rᵢ₋₁ .≤ x_vec .< rᵢ)
                r_grid = x_vec[nr]
                for (nz, z_grid) in enumerate(z_vec)
                    x_rcv = [r_grid, z_grid]
                    # x_ray = [rᵢ₋₁, zᵢ₋₁]
                    x_ray = [rᵢ, zᵢ]
                    t_ray = ray.c(sᵢ₋₁) * [ray.ξ(sᵢ₋₁), ray.ζ(sᵢ₋₁)]
                    t_ray /= dot(t_ray, t_ray) |> sqrt
                    n_ray = ray.c(sᵢ₋₁) * [-ray.ζ(sᵢ₋₁), ray.ξ(sᵢ₋₁)]
                    n_ray /= dot(n_ray, n_ray) |> sqrt
                    s = dot(x_rcv - x_ray, t_ray)
                    n = dot(x_rcv - x_ray, n_ray) |> abs
                    p_add = ray.P(sᵢ₋₁ + s, n)
                    if !(isnan(p_add) || isinf(p_add))
                        pressure[nr, nz] += p_add
                    end
                end
            end
        end
    end
    pressure
end

function point_pressure_from_ray(ray::Ray, x::Real, z::Real)
    displacement_from_normal(s) = perpendicular_displacement(
        (ray.x(s), ray.z(s)),
        -1/ray.gradient(s),
        (x, z)
    )
    
    arc_points = find_zeros(displacement_from_normal, 0, ray.s_max)
    
    distance_from_arc_point(s) = sqrt(
        (
            x - ray.x(s)
        )^2 + (
            z - ray.z(s)
        )^2
    )

    distances_from_arc_points = [
        distance_from_arc_point(s)
        for s in arc_points
    ]

    points = [
        (s = arc_points[i], n = distance_from_arc_point(arc_points[i]))
        for i in eachindex(arc_points)
    ]

    @show points

    closest_points = [
        point
        for point in points
        if point.n ≤ 2ray.W(point.s)
    ]

    @show closest_points

    ps = ComplexF64[
        ray.P(point.s, point.n)
        for point in closest_points
    ] |> sum
end

function point_pressure_from_rays(rays::AbstractVector{<:Ray}, x::Real, z::Real)
    p = [point_pressure_from_ray(ray, x, z) for ray in rays] |> sum
end

function pressure_field(rays::AbstractVector{<:Ray}, x_vec::AbstractVector{<:Real}, z_vec::AbstractVector{<:Real})
    p = [
        point_pressure_from_rays(rays, x, z)
        for x in x_vec, z in z_vec
    ]
end

# function populate_grid!(p::AbstractMatrix{<:Complex}, ray, nx, nz, x, z)
#     pcum = ComplexF64(0, 0)
#     for i in eachindex(ray.s_vec[1:end-1])
#         xlo, xhi = ray.x.(ray.s_vec[i:i+1]) |> extrema
#         !(xlo ≤ x < xhi) && return
#         rcv_point = [x, z]
#         displacement_transposed = (rcv_point - ray.point(s))'
#         s = displacement_transposed * ray.tangent(s)
#         n = displacement_transposed * ray.normal(s) |> abs
#         pcum += ray.P(s, n)
#     end
#     p[nx, nz] += pcum

#     if nx == nz == 0
#         return pcum
#     end
# end

raymodel_model = :jensen

struct RayModel <: Propagation
    scen::Scenario
    x_vec::Vector{Float64}
    z_vec::Vector{Float64}
    f::Float64
    rays::Vector{Ray}
    p::Matrix{ComplexF64}
    PL::Matrix{Float64}

    function RayModel(
        scen::Scenario,
        x_vec::AbstractVector{<:Real},
        z_vec::AbstractVector{<:Real},
        f::Real,
        launch_angles::AbstractVector{<:Real} = default_launch_angles(scen)
    )
        δθ₀ = launch_angles |> diff |> mean
        rays = [Ray(scen, θ₀, δθ₀, f) for θ₀ in launch_angles]
        
        # p₀_abs = map_beams_to_grid(rays, [scen.x + 1.0], [scen.z])[1] |> abs
        # p = map_beams_to_grid(rays, x_vec, z_vec)
        if raymodel_model == :root
            p = pressure_field(rays, x_vec, z_vec)

            # p₀_abs = point_pressure_from_rays(rays, x, z) |> abs # reinstate once problem solved
            ray = rays[1]
            @show p₀_abs = point_pressure_from_ray(ray, ray.x(√2), ray.z(√2)) |> abs

        elseif raymodel_model == :jensen
            p₀_abs = map_beams_to_grid(rays, [scen.x + 1.0], [scen.z])[1] |> abs
            p = map_beams_to_grid(rays, x_vec, z_vec)
        end

        # PL = @. -20log10(abs(p) / p₀_abs)
        # PL = -20log10.(p .|> abs)
        # PL = min.(PL, 100.0)
        # PL = max.(PL, 0.0)
        # PL[isnan.(PL)] .= 100.0
        PL = -20log10.(p .|> abs)
        PL = max.(0.0, PL)
        PL = min.(100.0, PL)

        new(scen, x_vec, z_vec, f, rays, p, PL)
    end
end

function Propagation(::Val{:ray},
    scen::Scenario,
    x_vec::AbstractVector{<:Real},
    z_vec::AbstractVector{<:Real},
    f::Real,
    launch_angles::AbstractVector{<:Real} = default_launch_angles(scen)
)
    RayModel(scen, x_vec, z_vec, f, launch_angles)
end
