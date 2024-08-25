export altimetry
export Altimetry

@implement_modelling altimetry 2

altimetry(::Val{:flat}, x::Real, y::Real) = 0.0

function altimetry(::Val{:damped_sinusoid},
    x::Real,
    y::Real;
    a::Real = 50.0,
    f::Real = 1e-4,
    s::Real = 0.0,
    d::Real = 10e3
)
    r = ocnson_hypot(x, y)
    ω = 2π * f
    a * exp(-r/d) * ocnson_sin(-ω * (r - s))
end
