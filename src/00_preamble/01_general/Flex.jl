public Flex

"""
```
OceanSonar.Flex :: Module
```

A `module` containing dispatching methods `import`ed from other modules.

Specifically:

* Contains mathematical functions that return `NaN` instead of erroring on mathematically invalid inputs,
such as `sqrt(-1::Number)`.

* `derivative` which dispatches appropriately
to `DataInterpolations.derivative`, `ForwardDiff.derivative` (not yet implemented), or `Symbolics.derivative` (not yet implemented).

The `OceanSonar.Flex`ible functions are a temporary implementation
until `NaNMath` functions are defined to fallback to their respective `Base` functions.
"""
baremodule Flex

using Base: Base, @eval, @show
using ..NaNMath
# Move to OceanSonar level of once ready to implement.
# using ..DataInterpolations: DataInterpolations, AbstractInterpolations
# using IntervalArithmetic: Interval
# using Statistics: Statistics
# using Symbolics: Num

eval(x) = Core.eval(Mod, x)
include(p) = Base.include(Mod, p)

# derivative(f::Function, x::Real) = ForwardDiff.derivative(f)
# derivative(f::AbstractInterpolations, x::Real, degree::Int = 1) = DataInterpolations.derivative(f, x, degree)
# derivative(expr::Expr, x::Num) = Symbolics.derivative(f)

# NumOrInterval = Union{<:Num, <:Interval}

for f in (:acos, :acosh, :asin, :atanh, :cos, :log, :log10, :log1p, :log2, :max, :min, :sin, :sqrt, :tan)
    @eval begin
        $f(x::Number) = NaNMath.$f(x)
        # $f(x::NumOrInterval) = Base.$f(x)
    end
end

# for f in (:max, :min, :(^))
#     @eval begin
#         $f(x::Number, y::Number) = NaNMath.$f(x, y)
#         $f(x::Num, y::Num) = Base.$f(x, y)
#         $f(x::Number, y::Num) = Base.$f(x, y)
#         $f(x::Num, y::Number) = Base.$f(x, y)
#     end
# end

# for f in (:max, :min)
#     @eval begin
#         import NaNMath: $f
#         # $f(x::Interval, y::Interval) = Base.$f(x, y)
#         # $f(x::Number, y::Interval) = Base.$f(x, y)
#         # $f(x::Interval, y::Number) = Base.$f(x, y)
#     end
# end

# (^)(x::Interval, y::Interval) = IntervalArithmetic.:(^)(x, y)
# (^)(x::Number, y::Interval) = IntervalArithmetic.:(^)(x, y)
# (^)(x::Interval, y::Number) = IntervalArithmetic.:(^)(x, y)

# for f in (:maximum, :minimum, :extrema)
#     @eval begin
#         $f(x::AbstractArray{<:Real}) = NaNMath.$f(x)
#         # $f(x::AbstractArray{<:NumOrInterval}) = Base.$f(x)
#     end
# end

# for f in (:sum, :median, :mean, :var, :std)
#     @eval begin
#         $f(x::AbstractArray{<:Real}) = NaNMath.$f(x)
#         # $f(x::AbstractArray{<:NumOrInterval}) = Statistics.$f(x)
#     end
# end

end
