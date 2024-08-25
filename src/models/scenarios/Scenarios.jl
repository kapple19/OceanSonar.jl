module Scenarios

using ...Auxiliary
using ...Structures

munk_profile = let
    cel = Celerity("munk")
    ocn = Medium(cel)
    env = Environment(ocn)
    src = Entity(1e3, 1e3)
    Scenario(env, src)
end

parabolic_bathymetry = let
    cel = Celerity(1520.0)
    bty = Bathymetry("parabolic")
    ocn = Medium(cel)
    env = Environment(ocn, bty)
    src = Entity(1e3, 1e3)
    Scenario(env, src)
end

end