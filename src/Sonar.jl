module Sonar
using ..OACBase
using ..RayTrace

# ⊕(L1, L2) = 10 * log10(10.0^(L1/10) + 10.0^(L2/10))
# ⊖(L1, L2) = 10 * log10(10.0^(L1/10) - 10.0^(L2/10))

# Sonar Types
include("sonar/types.jl")
# include("sonar/inputs.jl")
include("sonar/parameters.jl")
# include("sonar/equations.jl")

export SonarMode
export Passive
export Intercept
export Active
export Bistatic

export propagation_loss
export total_noise_level
export directivity_index
export signal_to_noise_ratio_passive_intercept
export signal_to_noise_ratio_active
export signal_to_noise_ratio_bistatic

end