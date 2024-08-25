module OceanCelerities

using ...Auxiliary: univariate
using ...Structures: Celerity

"""
Munk celerity profile.

Taken from Equation TODO of Jensen, et al (2011).
"""
munk = let
    function fcn(x::Real, z::Real; ϵ::Real = 7.37e-3)
        z̃ = 2/1300 * (z - 1300.0)
        1500(1.0 + ϵ * (z̃ - 1.0 + exp(-z̃)))
    end

    Celerity(fcn, z_imp = [0.0, 5e3])
end

"""
Simplified north atlantic celerity profile.

Taken from Table TODO of Jensen, et al (2011).
"""
north_atlantic = let
    z_data = Float64[0, 300, 1200, 2e3, 5e3]
    c_data = Float64[1522.0, 1502, 1514, 1496, 1545]
    fcn_tmp, _ = univariate(z_data, c_data)
    fcn(x, z) = fcn_tmp(z)

    Celerity(fcn, z_imp = z_data)
end

"""
Simplified mediterranean celerity profile.

Taken from Table TODO of Jensen, et al (2011).
"""
mediterranean = let
    z_data = Float64[0, 100, 2500]
    c_data = Float64[1540, 1510, 1550]
    fcn_tmp, _ = univariate(z_data, c_data)
    fcn(x, z) = fcn_tmp(z)

    Celerity(fcn, z_imp = z_data)
end

"""
Simplified arctic celerity profile.

Taken from Table TODO of Jensen, et al (2011).
"""
arctic = let
    z_data = Float64[0, 300, 4000]
    c_data = Float64[1438, 1460, 1519.2]
    fcn_tmp, _ = univariate(z_data, c_data)
    fcn(x, z) = fcn_tmp(z)
    
    Celerity(fcn, z_imp = z_data)
end

"""
Squared-index profile.

Taken from Equation TODO of Jensen, et al (2011).
"""
squared_index = let
    function fcn(x::Real, z::Real; c₀::Real = 1500.0)
        c₀ / sqrt(1.0 + 2.4z / c₀)
    end
    
    Celerity(fcn, z_imp = [0.0, 1e3])
end

end