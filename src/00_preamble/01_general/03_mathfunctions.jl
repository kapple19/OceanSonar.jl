"""
```julia
OceanSonar.MathFunctions
```

A `module` of functions that inherit behaviours from
`NaNMath`, `Symbolics`, and `IntervalArithmetic`.

Run `names(OceanSonar.MathFunctions)` to access the list of functions.

Such functions are imported into the scope of `OceanSonar`
to reduce verbosity of usage.

# Extended Help

Normally Julia math functions throw an error for invalid bounds.

```julia-repl
julia> sqrt(-1)
ERROR: DomainError with -1.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
```

In some math applications it is preferable to return `NaN` instead.

```julia-repl
julia> NaNMath.sqrt(-1)
NaN
```

which is inherited by `OceanSonar.MathFunctions`.

```julia-repl
julia> OceanSonar.sqrt(-1)
NaN
```

However the `NaNMath` package doesn't support
preservation of `Num`bers from `Symbolics`.

```julia-repl
julia> NaNMath.sqrt(Num(2))
1.4142135623730951
```

and neither do `Base` functions.

```julia-repl
julia> sqrt(Num(2))
1.4142135623730951
```

Thus `OceanSonar.MathFunctions` are designed so that
internally written algorithms
will present a neat equation based on `Num` inputs.

```julia-repl
julia> OceanSonar.sqrt(Num(2))
sqrt(2)
```

For user ease, `OceanSonar` re-exports `Num` from `Symbolics`.

Finally, it is often useful to obtain the range of output values of a function
for a certain range of inputs.
Such functionality is provided by `IntervalArithmetic`.

```julia-repl
julia> interval(1, 2) |> sqrt
[1.0, 1.41422]_com
```

However, at the time of writing, `NaNMath` functions were not designed for
`Interval` inputs.

```julia-repl
julia> interval(1, 2) |> NaNMath.sqrt
ERROR: StackOverflowError
```

Thus `OceanSonar.MathFunctions` defines methods for `Interval` inputs
to fallback to Julia's `Base` functions.

```julia-repl
julia> interval(1, 2) |> OceanSonar.sqrt
```

For user ease, `OceanSonar` re-exports `interval` from `IntervalArithmetic`.

In future the above-mentioned packages may improve interoperability
to address the above-demonstrated limitations.
In such a case, deletion of the math function definitions in `OceanSonar.MathFunctions`
is simple, and `OceanSonar` functionality (and any dependencies on `OceanSonar`)
will continue to work as normal since the implementation is
an overwriting of the functions from `Base`.

Currently, math functions in `OceanSonar.MathFunctions`
are defined ad-hoc.
"""
module MathFunctions # consider `baremodule` instead

using ..IntervalArithmetic: Interval
using ..NaNMath: NaNMath
using ..OceanSonar: styletext
using ..Symbolics: Num, Term, wrap

macro initialise_math_function(function_name)
    function_type_name = Symbol(styletext(:Pascal, function_name |> String) * "FunctionType")
    @eval begin
        struct $function_type_name <: Function end
        const $function_name = $function_type_name()
    end
end

@initialise_math_function sqrt

sqrt(x::Real) = NaNMath.sqrt(x)
sqrt(x::Num) = Term(Base.sqrt, [x]) |> wrap
sqrt(x::Interval) = Base.sqrt(x)

public sqrt

end # module MathFunctions

#######################################################################

for name in names(MathFunctions)
    name == :MathFunctions && continue
    isdefined(MathFunctions, name) || continue
    @debug "Overwriting $name from `Base` with `OceanSonar.MathFunctions`'s definition."
    @eval begin
        using .MathFunctions: $name
        @doc """
        An alternative math function implementation
        that inherits from `NaNMath`, `Symbolics`, and `IntervalArithmetic`.

        Run `methods` on this function for a list of methods.

        See `?OceanSonar.MathFunctions` for more information.
        """
        $name
    end
end

public MathFunctions
public sqrt
