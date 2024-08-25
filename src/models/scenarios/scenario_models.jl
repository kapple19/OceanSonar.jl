include("Scenarios.jl")

"""
```
scenarios
```

List of scenarios.
"""
scenarios = list_models(Scenarios)

function Structures.Scenario(model::String)
    !(model in scenarios) && error("unrecognised scenario model.")
    getproperty(Scenarios, Symbol(model))
end