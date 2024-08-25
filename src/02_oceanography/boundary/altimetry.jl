export altimetry
export Altimetry

@implement_2D_modelling altimetry

altimetry(::Val{:flat}, x::Real, y::Real) = 0.0

sine_default = (
    a = 500.0,
    f = 1e-4,
    s = 0.0
)

function altimetry(::Val{:sine},
    x::Real,
    y::Real;
    a::Real = sine_default.a,
    f::Real = -sine_default.f,
    s::Real = sine_default.s
)
    r = hypot(x, y)
    a * ocnson_sin(2π * f*(r - s))
end
