"""
```
Bivariate <: Functor
```

`Bivariate` is both an abstract type and a function that produces an interpolation-extrapolation object.

```
itp::Bivariate = Univariate(args...; kwargs...)
```

Returns a bivariate interpolator-extrapolator object
whose behaviour is specified by TODO.

TODO: Implement.

For example,

```julia
itp = Bivariate(1:10, 1:20, rand(10, 20))
itp(2.4, 11.5)
```
"""
function Bivariate end

function Bivariate(func::Function)
    try
        func(0.0, 0.0)
    catch
        error("Inputted function not bivariate")
    end
    return func
end

function Bivariate(F_val::Real)
    func(a::Real, b::Real) = F_val
    return Bivariate(func)
end

function Bivariate(
    ::Nothing,
    b_vec::AbstractVector{<:Real},
    F_vec::AbstractVector{<:Real}
)
    itp = Univariate(b_vec, F_vec)
    func(a::Real, b::Real) = itp(b)
end