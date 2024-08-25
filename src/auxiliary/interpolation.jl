@doc """
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

@doc """
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