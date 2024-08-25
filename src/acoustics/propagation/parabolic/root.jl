export ParabolicConfig

include("config.jl")
include("starter.jl")
include("marcher.jl")

# Starter: 6.4.1.2

struct Parabolic <: Propagation
    x
    z
    p
    PL

    function Parabolic(scen::Scenario,
        config::ParabolicConfig = ParabolicConfig();
        ranges::AbstractVector{<:AbstractFloat} = default_ranges(scen),
        depths::AbstractVector{<:AbstractFloat} = default_depths(scen)
    )
        starter = FieldStarter(config.field_starter, scen)
        ψ = [starter.(depths)]
        
        k₀ = 2π * scen.f / scen.env.ocn.cel(0, scen.z)
        p = [
            [
                ψel/√(x) * cis(k₀*x - π/4)
                for ψel in ψcol
            ] for ψcol in ψ, x in ranges
        ]
        PL = @. -20log10(p |> abs)
        new(ranges, depths, p, PL)
    end
end