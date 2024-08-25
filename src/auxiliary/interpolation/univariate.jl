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