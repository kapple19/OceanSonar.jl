@reexport module Auxiliary

using Interpolations

export uniquesort!
export univariate
export bivariate

"""
```
uniquesort!
```

Composition of `sort!` then `unique`.
"""
uniquesort! = (unique! ∘ sort!)

include("univariate.jl")
include("bivariate.jl")

function list_models(m::Module)
    models = names(m, all = true) .|> string
    the_filter(s) = !contains(s, "#")
    filter!(the_filter, models)
    @assert contains(string(m), models[1])
    deleteat!(models, 1)
    filter!(!=("eval"), models)
    filter!(!=("include"), models)
end

end