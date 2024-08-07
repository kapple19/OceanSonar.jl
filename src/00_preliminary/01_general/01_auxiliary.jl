export uniquesort!
export cossin
export ⊕

const uniquesort! = unique! ∘ sort!

const cossin = reverse ∘ sincos

function isalphanumeric(char::AbstractChar)
    '0' ≤ char ≤ '9' && return true
    'a' ≤ char ≤ 'z' && return true
    'A' ≤ char ≤ 'Z' && return true
    return false
end

# TODO: Update when Unitful.jl is incorporated into package.
function ⊕(levels...)
    10log10(
        (
            @. 10^(levels/10)
        ) |> splat(+)
    )
end