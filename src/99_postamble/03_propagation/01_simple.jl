export Propagation

function Propagation(::Model{:Simple},
    scen::Scenario,
    ranges::AbstractVector{<:Real},
    azimuths::AbstractVector{<:Real},
    depths::AbstractVector{<:Real}
)
    x₀ = scen.own.position.x
    y₀ = scen.own.position.y
    z₀ = scen.own.position.z
    z_bot = scen.env.bot.z(x₀, y₀)

    function propagate(r, θ, z)
        c = scen.env.ocn.c(x₀, y₀, z₀)
        λ = c / scen.proc.f

        return pressure_field(:SingleReflectionLloydMirror,
            r, z, z₀, z_bot,
            λ, c
        )
    end

    p = [propagate(r, θ, z) for r in ranges, θ in azimuths, z in depths]

    Propagation(ranges, azimuths, depths, p, p .|> propagation_loss)
end
