"""
`Univariate` is both an abstract type and a function that produces an interpolation-extrapolation object.

```
itp::Univariate = Univariate(args...; kwargs...)
```

Returns univariate interpolator-extrapolator object
whose behaviour is specified by TODO.

TODO: Implement.

For example,

```julia
itp = Univariate(1:10, rand(10))
itp(2.4)
```
"""
function Univariate end

function Univariate(func::Function)
    try
        func(0.0)
    catch
        error("Inputted function not univariate.")
    end
    return func
end

function Univariate(F_val::Real)
    func(a::Real) = F_val
    return Univariate(func)
end

function Univariate(
    a_vec::AbstractVector{<:Real},
    F_vec::AbstractVector{<:Real}
)
    itp = linear_interpolation(
        a_vec, F_vec,
        extrapolation_bc = Flat()
    )
    func(a::Real) = itp(a)
    return Univariate(func)
end