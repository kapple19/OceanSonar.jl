export ocean_celerity

struct OceanCelerityFunctionType <: ModellingFunction end

const ocean_celerity = OceanCelerityFunctionType()

"""
```
ocean_celerity("Jensen", T::Real, S::Real, z::Real)::Real
```
Equation 1.1 of Jensen, et al (2011).
"""
function ocean_celerity(::ModelName{:Jensen}, T::Real, S::Real, z::Real)
    c = 1449.2 + 4.6T - 0.055T^2 + 0.00029T^3 + (1.34 - 0.01T) * (S - 35) + 0.016z
end

"""
```
ocean_celerity("Del Grosso", T::Real, S::Real, P::Real)
```
"""
function ocean_celerity(::ModelName{:DelGrosso}, T::Real, S::Real, P::Real)
    T² = T^2
    T³ = T^3
    P² = P^2
    P³ = P^3
    
    V_T = 4.5721T − 4.4532e−2T² − 2.6045e−4T³ + 7.9851e−6T^4
    V_P = 1.60272e−1P + 1.0268e−5P² + 3.5216e−9P³ − 3.3603e−12P^4
    V_S = 1.39799(S − 35) + 1.69202e−3(S − 35)^2
    V_STP = (S − 35) * (
        −1.1244e−2T + 7.7711e−7T² + 7.7016e−5P − 1.2943e−7P² + 3.1580e−8P*T + 1.5790e−9P*T²
    ) + P * (
        −1.8607e−4T + 7.4812e−6T² + 4.5283e−8T³
    ) + P² * (
        −2.5294e−7T + 1.8563e−9T²
    ) + P³ * (−1.9646e−10T)

    V = 1449.14 + V_T + V_P + V_S + V_STP
end