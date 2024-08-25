module Bathymetries
using ...Auxiliary
using ...Structures

"""
Parabolic bathymetry.

Taken from Equation 3.127 of Jensen, et al (2011).
"""
parabolic = let
    function fcn(x::Real; b = 250e3, c = 250)
        z = 0.002b * √(1 + x/c)
    end

    Bathymetry(fcn, x_imp = [0.0, Inf])
end

"""
Dickins seamount bathymetry.

Taken from TODO of Jensen, et al (2011).
"""
dickins = let
    x_data = Float64[0, 10, 20, 30, 100] * 1e3
    z_data = Float64[3, 3, 0.5, 3, 3] * 1e3
    fcn, _ = univariate(x_data, z_data)
    
    Bathymetry(fcn, x_imp = x_data)
end

end