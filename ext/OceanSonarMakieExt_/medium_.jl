get_bivariate(::Type{Celerity}, med::Medium) = med.cel
get_bivariate(::Type{OceanSonar.Density}, med::Medium) = med.den

function visual!(type::Type{<:Bivariate}, med::Medium,
    x_lo::Real, x_hi::Real,
    z_lo::Real, z_hi::Real;
    kw...
)
    visual!(get_bivariate(type, med), x_lo, x_hi, z_lo, z_hi; kw...)
    return current_figure()
end