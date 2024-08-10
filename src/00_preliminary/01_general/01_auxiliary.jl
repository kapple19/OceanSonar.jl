export uniquesort!
export cossin
export ⊕

const uniquesort! = unique! ∘ sort!

const cossin = reverse ∘ sincos
const cossind = reverse ∘ sincosd

magcossin(r::Number, θ::Number) = r .* cossin(θ)

magang(x::Real, y::Real) = ((y, x),) .|> ((hypot, atan) .|> splat)
magang(z::Number) = z |> reim |> splat(magang)

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