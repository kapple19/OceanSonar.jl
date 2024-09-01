module MathFunctions

using ..OceanSonar: styletext

using ..NaNMath
using ..Symbolics
using ..IntervalArithmetic

# public sqrt

macro initialise_math_function(function_name)
    function_type_name = Symbol(styletext(:Pascal, function_name |> String) * "FunctionType")
    @eval begin
        struct $function_type_name <: Function end
        const $function_name = $function_type_name()
    end
end

@initialise_math_function sqrt

sqrt(x::Real) = NaNMath.sqrt(x)
sqrt(x::Num) = Symbolics.Term(sqrt, [x]) |> Symbolics.wrap
sqrt(x::Interval) = Base.sqrt(x)

end # module MathFunctions

# using .MathFunctions
# 
# `public` doesn't work inside macros.
# for name in names(MathFunctions)
#     name == :MathFunctions && continue
#     isdefined(MathFunctions, name) || continue
#     @eval begin
#         using .MathFunctions: $name
#         public $name
#     end
# end

using .MathFunctions: sqrt
public sqrt