"""
```
function bivariate(fcn::Function; x_imp = [-Inf, Inf], y_imp = [-Inf, Inf])
```

Checks the inputted function is `bivariate`. Returns the function `fcn` and a vector of `imp`ortant input points for the domain of inputs (`x`, `y`) for `fcn(x, y)`: `extrema(x_imp)` defines the `x` domain limits for `x`, `extrema(y_imp)` the domain limits for `y`.
"""
function bivariate(fcn::Function; x_imp = [-Inf, Inf], y_imp = [-Inf, Inf])
    try
        fcn(0.0, 0.0)
    catch
        error("Inputted function not bivariate.")
    end

    return fcn, uniquesort!(x_imp), uniquesort!(y_imp)
end

"""
```
bivariate(z::Real)
```

Returns a bivariate function of constant output `z`. 
"""
function bivariate(z::Real; x_imp = [-Inf, Inf], y_imp = [-Inf, Inf])
    fcn(x::Real, y::Real) = z
    bivariate(fcn, x_imp = x_imp, y_imp = y_imp)
end

"""
```
bivariate(
    x::AbstractVector{<:Real}, y::AbstractVector{<:Real}, Z::AbstractMatrix{<:Real})
```

Returns a bivariate linear interpolation and flat extrapolation of input vectors `x` and `y` for output matrix `Z`.
"""
function bivariate(
    x::AbstractVector{<:Real},
    y::AbstractVector{<:Real},
    Z::AbstractMatrix{<:Real}
)
    itp = linear_interpolation((x, y), Z, extrapolation_bc = Flat())
    bivariate((x′, y′) -> itp(x′, y′), x_imp = x, y_imp = y)
end

"""
```
function bivariate(
    x::AbstractVector{<:Real},
    yz::AbstractVector{<:AbstractMatrix{<:Real}}
)
```

Returns a bivariate linear interpolation and flat extrapolation of input vector `x`, associated with input row vectors `yz[n][:, 1]` which pairs with output vectors `yz[n][:, 2]` for ``n = 1, 2, ...``.
"""
function bivariate(
    x::AbstractVector{<:Real},
    yz::AbstractVector{<:AbstractMatrix{<:Real}}
)
    @assert length(x) == length(yz)
    # task: check column size of yz elements is 2
    y = vcat([yz′[:, 1] for yz′ in yz]...) |> uniquesort!
    function itp_col(yz′)
        u, _ = univariate(yz′[:, 1], yz′[:, 2])
        [u(y′) for y′ in y]
    end
    Z = hcat([itp_col(yz′) for yz′ in yz]...)'
    bivariate(x, y, Z)
end