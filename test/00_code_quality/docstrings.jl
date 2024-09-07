using OceanSonar
using Test
using Base.Docs

@test begin
    undocs = [
        name
        for name in undocumented_names(OceanSonar, private = true)
        if name ∉ [:eval, :include]
    ]

    if isempty(undocs)
        true
    else
        println()
        @info "Undocumented names:"
        for undoc in undocs
            @info string("* ", undoc)
        end
        println()
        false
    end
end
