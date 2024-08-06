# TODO: Update when Unitful.jl is incorporated into package.
function ⊕(levels...)
    10log10(
        (
            @. 10^(levels/10)
        ) |> splat(+)
    )
end