visual!(::Type{Altimetry}, env::Environment; kw...) = visual!(env.ati; kw...)
visual!(::Type{Bathymetry}, env::Environment; kw...) = visual!(env.bty; kw...)

function visual!(::Type{Boundary}, env::Environment; kw...)
    visual!(env.ati; kw...)
    visual!(env.bty; kw...)
end

# TODO: Automate through `Bivariate`s.

function visual!(::Type{OceanCelerity}, env::Environment; kw...)
    visual!(Celerity, env.ocn; kw...)
    visual!(Boundary, env; kw...)
end

function visual!(::Type{OceanDensity}, env::Environment; kw...)
    visual!(Density, env.ocn; kw...)
    visual!(Boundary, env; kw...)
end

visual!(env::Environment; kw...) = visual!(OceanCelerity, env)