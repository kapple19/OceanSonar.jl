"""
```
struct Celerity <: OcnSon
```

Properties:

* `fcn::Function`
* `x_imp::Vector{<:Real}`
* `z_imp::Vector{<:Real}`
"""
struct Celerity <: OcnSon
    fcn::Function
    x_imp::Vector{<:Float64}
    z_imp::Vector{<:Float64}

    function Celerity(
        fcn::Function;
        x_imp::Vector{<:Real} = [-Inf, Inf],
        z_imp::Vector{<:Real} = [0.0, Inf]
    )
        fcn, x_imp, z_imp = bivariate(fcn, x_imp = x_imp, y_imp = z_imp)
        new(fcn, x_imp, z_imp)
    end
end

(c::Celerity)(args...; kwargs...) = c.fcn(args...; kwargs...)

function Celerity(args...)
    fcn, x_imp, z_imp = bivariate(args...)
    Celerity(fcn, x_imp = x_imp, z_imp = z_imp)
end