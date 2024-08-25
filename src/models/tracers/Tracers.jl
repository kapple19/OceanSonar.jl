module Tracers
using ...Structures

using ForwardDiff: derivative

ray = let
    TraceType = Ray

    function def_trace(scn::Scenario)
        cel = scn.env.ocn.cel

        function trace!(
            du::AbstractVector{<:Real},
            u::AbstractVector{<:Real},
            _,
            s::Real
        )
            x, z, ξ, ζ, τ = u
            c = cel(x, z)
            dc_dx = derivative(x -> cel(x, z), x)
            dc_dz = derivative(z -> cel(x, z), z)

            du[1] = dx = c * ξ
            du[2] = dz = c * ζ
            du[3] = dξ = -dc_dx / c^2
            du[4] = dζ = -dc_dz / c^2
            du[5] = dτ = 1 / c

            nothing
        end

    end

    function prep_init_conds(scn::Scenario)
        x₀ = 0.0
        z₀ = scn.src.z
        τ₀ = 0.0

        u₀ = [x₀, z₀, NaN64, NaN64, τ₀]
    end

    function def_update_init_conds(scn::Scenario)
        cel = scn.env.ocn.cel

        function update_init_conds!(u₀::AbstractVector{<:Real}, θ₀::Real)
            x₀, z₀ = u₀[1:2]
            c₀ = cel(x₀, z₀)

            u₀[3] = ξ₀ = cos(θ₀) / c₀
            u₀[4] = ζ₀ = sin(θ₀) / c₀

            nothing
        end
    end

    Tracer(TraceType, def_trace, prep_init_conds, def_update_init_conds)
end # ray

gaussian_beam = let
    TraceType = Beam

    function def_trace(scn::Scenario)
        cel = scn.env.ocn.cel
        ray_trace! = ray.def_trace(scn)

        function trace!(
            du::AbstractVector{<:Real},
            u::AbstractVector{<:Real},
            _,
            s::Real
        )
            ray_trace!(du, u, nothing, s)

            x, z, ξ, ζ = u[1:4]
            p_real, p_imag, q_real, q_imag = u[6:9]

            dcdx(x, z) = derivative(x -> cel(x, z), x)
            dcdz(x, z) = derivative(z -> cel(x, z), z)

            c = cel(x, z)
            d²c_dx² = derivative(x -> dcdx(x, z), x)
            d²c_dz² = derivative(z -> dcdx(x, z), z)
            d²c_dxdz = derivative(x -> dcdz(x, z), x)
            c_nn = c^2 * (
                d²c_dx² * ζ^2
                - 2d²c_dxdz * ξ * ζ
                + d²c_dz² * ξ^2
            )

            du[6] = dp_real = c_nn * q_real / c^2
            du[7] = dp_imag = c_nn * q_imag / c^2
            du[8] = dq_real = c * p_real
            du[9] = dq_imag = c * p_imag
        end
    end

    function prep_init_conds(scn::Scenario)
        u₀ = ray.prep_init_conds(scn)
        x₀, z₀ = u₀[1:2]

        cel = scn.env.ocn.cel

        f = scn.src.f
        ω = 2π * f
        λ = cel(x₀, z₀) / f
        W₀ = 20λ

        p₀_real = 1.0
        p₀_imag = 0.0
        q₀_real = 0.0
        q₀_imag = ω * W₀^2 / 2

        push!(u₀,
            p₀_real, p₀_imag, q₀_real, q₀_imag
        )
    end

    def_update_init_conds = ray.def_update_init_conds

    Tracer(TraceType, def_trace, prep_init_conds, def_update_init_conds)
end # gaussian_beam

# geometric_beam = let
#     function def_trace()

#     end

#     function prep_init_conds()

#     end

#     function update_init_conds!()

#     end

#     TraceType = Beam

#     Tracer(def_trace, prep_init_conds, def_update_init_conds, TraceType)
# end # geometric_beams

end