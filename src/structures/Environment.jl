"""
```
mutable struct Environment <: OcnSon
```
"""
mutable struct Environment <: OcnSon
    ocn::Medium
    bty::Bathymetry

    Environment() = new()
end

function Environment(args...)
    env = Environment()
    for arg in args
        Environment!(env, arg)
    end
    return env
end

function Environment!(env::Environment, ocn::Medium)
    env.ocn = ocn
    return env
end

function Environment!(env::Environment, bty::Bathymetry)
    env.bty = bty
    return env
end