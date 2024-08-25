export AtmosphereCelerity
export atmosphere_celerity

function AtmosphereCelerity(model::Val)
    fun(x::Real, z::Real) = atmosphere_celerity(model, x, z)
    Celerity(fun)
end

function atmosphere_celerity(::Val{:standard}, x::Real, z::Real)
    c = 343.0
end

# "<https://en.wikipedia.org/wiki/Speed_of_sound#Altitude_variation_and_implications_for_atmospheric_acoustics>"
# function atmosphere_celerity(::Val{:wikipedia})
#     # TODO
# end