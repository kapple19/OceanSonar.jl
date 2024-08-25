export uniquesort!

(..)(lo, hi) = interval(lo, hi)
uniquesort! = unique! ∘ sort!

# series125(n::Integer) = (1 + (n % 3)^2) * 10^(n ÷ 3)

# function series125(; max::Real = NaN, length::Real = NaN)

# end

include("series125.jl")

include("stringcases.jl")
include("modelling.jl")

include("interpolation/root.jl")
include("units/root.jl")