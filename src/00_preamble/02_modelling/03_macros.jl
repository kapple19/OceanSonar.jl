"""
```
@implement_metric_function function_name
```

Implements a new `MetricFunction <: Function` instance ready for `Model` dispatching.

Specifically:

1. Defines a concrete `struct` subtype of `MetricFunction`.
2. Defines a `const` instance of the new subtype with the name `function_name`.
3. Adds the new function to the list of `metric_functions`.

See also: [`Model`](@ref), [`OceanSonar.MetricFunction`](@ref).

# Example

```
@implement_metric_function sound_speed_profile
sound_speed_profile(::Model{:MyModel}, z::Real) = 1500.0 + exp(-z^2)
sound_speed_profile("My Model", 1e3)
```
"""
macro implement_metric_function(fcn_name)
    fcn_type_name = Symbol(pascaltext(fcn_name |> String) * "MetricFunctionType")

    @eval begin
        struct $fcn_type_name <: MetricFunction end
        const $fcn_name = $fcn_type_name()
        push!(metric_functions, $fcn_name)
    end
end
